# Converted from atlantis.yaml workflows.custom.plan.steps[2].
__atlantis_out="$('sh' '-c' 'sh ../scripts/gen-env.sh')" || exit 1
__atlantis_env="$(printf %s "$__atlantis_out" | python3 -c 'import shlex, sys
line = sys.stdin.read().strip()
if line:
    lex = shlex.shlex(line, posix=True)
    lex.whitespace = ","
    lex.whitespace_split = True
    for pair in lex:
        key, sep, value = pair.partition("=")
        key = key.strip()
        if not sep or not key or any(c in key for c in " \t"):
            sys.exit("invalid environment variable definition: " + pair)
        print("export " + key + "=" + shlex.quote(value))
')" || exit 1
eval "$__atlantis_env"
