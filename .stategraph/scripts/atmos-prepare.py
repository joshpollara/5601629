#!/usr/bin/env python3
"""Write the Atmos-generated files of one component instance for an
Orchestration run.

Reads .stategraph/atmos/instances.json, which atmos-to-stategraph.py wrote, and
the TERRATEAM_ROOT, TERRATEAM_DIR, and TERRATEAM_WORKSPACE variables of the run.
Writes atmos.tfvars.json, backend.tf.json, providers_override.tf.json, and
.atmos.env in the working directory.
"""

import hashlib
import json
import os
import platform
import shutil
import subprocess
import sys
import tempfile
import urllib.request

ROOT = os.environ['TERRATEAM_ROOT']
DIR = os.path.normpath(os.environ['TERRATEAM_DIR'])
WORKSPACE = os.environ['TERRATEAM_WORKSPACE']
CONFIG = os.path.join(ROOT, '.stategraph', 'atmos', 'instances.json')
GENERATED = os.path.join(ROOT, '.stategraph', 'atmos', 'generated')
RELEASES = 'https://github.com/cloudposse/atmos/releases/download'


def shell_single(s):
    return "'" + str(s).replace("'", "'\"'\"'") + "'"


def install_atmos(version):
    found = shutil.which('atmos')
    if found:
        out = subprocess.run([found, 'version', '--check=false'], capture_output=True, text=True)
        if version in out.stdout + out.stderr:
            return found
    arch = {'x86_64': 'amd64', 'amd64': 'amd64', 'aarch64': 'arm64', 'arm64': 'arm64'}[platform.machine().lower()]
    system = platform.system().lower()
    cache = os.path.join(os.environ.get('XDG_CACHE_HOME') or os.path.expanduser('~/.cache'), 'stategraph', 'atmos', version)
    path = os.path.join(cache, 'atmos')
    if os.path.exists(path):
        return path
    os.makedirs(cache, exist_ok=True)
    name = 'atmos_{}_{}_{}'.format(version, system, arch)
    base = '{}/v{}/'.format(RELEASES, version)
    with urllib.request.urlopen(base + name) as r:
        body = r.read()
    with urllib.request.urlopen(base + 'atmos_{}_SHA256SUMS'.format(version)) as r:
        sums = r.read().decode()
    want = [line.split()[0] for line in sums.splitlines() if line.strip().endswith(name)]
    if not want or hashlib.sha256(body).hexdigest() != want[0]:
        sys.exit('atmos-prepare: the checksum of {} does not match'.format(name))
    tmp = path + '.tmp'
    with open(tmp, 'wb') as f:
        f.write(body)
    os.chmod(tmp, 0o755)
    os.replace(tmp, path)
    return path


def write_json(name, value):
    with open(name, 'w') as f:
        json.dump(value, f, indent=2, sort_keys=True)
        f.write('\n')


def main():
    with open(CONFIG) as f:
        cfg = json.load(f)
    try:
        inst = cfg['instances'][DIR][WORKSPACE]
    except KeyError:
        sys.exit('atmos-prepare: {} has no Atmos instance for the workspace {}'.format(DIR, WORKSPACE))
    atmos_dir = os.path.join(ROOT, cfg['atmos_dir'])
    env = {
        'ATMOS_CLI_CONFIG_PATH': os.path.abspath(atmos_dir),
        'ATMOS_BASE_PATH': os.path.abspath(os.path.join(ROOT, cfg['base_path'])),
        'TF_IN_AUTOMATION': 'true',
    }
    if cfg['static']:
        src = os.path.join(GENERATED, DIR, WORKSPACE)
        for name in sorted(os.listdir(src)):
            if name == '.atmos.env':
                continue
            shutil.copyfile(os.path.join(src, name), name)
        extra = os.path.join(src, '.atmos.env')
        lines = []
        if os.path.exists(extra):
            with open(extra) as f:
                lines.append(f.read())
    else:
        atmos = install_atmos(cfg['atmos_version'])
        fd, out = tempfile.mkstemp(suffix='.json')
        os.close(fd)
        subprocess.run([atmos, 'describe', 'stacks', '--stack', inst['stack'],
                        '--components', inst['component'], '--component-types', 'terraform',
                        '--format', 'json', '--file', out],
                       cwd=atmos_dir, check=True, stdout=sys.stderr)
        with open(out) as f:
            stacks = json.load(f)
        os.unlink(out)
        x = stacks[inst['stack']]['components']['terraform'][inst['component']]
        write_json('atmos.tfvars.json', x.get('vars') or {})
        if cfg['generate_backend'] and x.get('backend_type'):
            write_json('backend.tf.json', {'terraform': {'backend': {x['backend_type']: x.get('backend') or {}}}})
        if x.get('providers'):
            write_json('providers_override.tf.json', {'provider': x['providers']})
        if x.get('generate'):
            subprocess.run([atmos, 'terraform', 'generate', 'files', inst['component'], '-s', inst['stack']],
                           cwd=atmos_dir, check=True, stdout=sys.stderr)
        env.update({k: '' if v is None else v for k, v in (x.get('env') or {}).items()})
        lines = []
    lines.insert(0, ''.join('export {}={}\n'.format(k, shell_single(env[k])) for k in sorted(env)))
    with open('.atmos.env', 'w') as f:
        f.write(''.join(lines))


if __name__ == '__main__':
    main()
