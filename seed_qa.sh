#! /bin/bash

ELIXIR_SCRIPT=$(cat <<EOM
    priv_dir = "#{:code.priv_dir(:stat)}";
    code_dir = Path.dirname(priv_dir);                             
    seed_script = Path.join([priv_dir, "repo", "seeds.exs"]);

    File.cd code_dir;
    Code.eval_file(seed_script);
EOM
)


gigalixir ps:migrate
gigalixir ps:ssh -- su gigalixir -c /app/bin/stat rpc eval "$ELIXIR_SCRIPT"
