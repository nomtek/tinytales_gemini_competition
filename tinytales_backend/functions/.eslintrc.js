module.exports = {
  root: true,
  env: {
    es6: true,
    node: true,
  },
  extends: [
    "eslint:recommended",
    "plugin:import/errors",
    "plugin:import/warnings",
    "plugin:import/typescript",
    "plugin:@typescript-eslint/recommended",
  ],
  parser: "@typescript-eslint/parser",
  parserOptions: {
    // project: ["tsconfig.json", "tsconfig.dev.json"],
    project: false,
    sourceType: "module",
  },
  ignorePatterns: [
    "/lib/**/*", // Ignore built files.
    "/generated/**/*", // Ignore generated files.
  ],
  plugins: ["@typescript-eslint", "import"],
  rules: {
    quotes: ["error", "double"],
    "no-async-promise-executor": ["off", "always"],
    "object-curly-spacing": ["off", "always"],
    "import/no-unresolved": 0,
    indent: ["off", "always"],
    "operator-linebreak": ["off", "always"],
  },
};
