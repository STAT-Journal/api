
import type { CodegenConfig } from '@graphql-codegen/cli';

const config: CodegenConfig = {
  overwrite: true,
  schema: "http://localhost:4000/api/graphql",
  documents: "src/gql/**/*.graphql",
  generates: {
    "src/gql/codegen/": {
      preset: 'client',
      plugins: [],
    }
  }
};

export default config;
