/** @type {import('jest').Config} */
module.exports = {
    testEnvironment: 'node',
    transform: {},            // без ts/babel трансформаций
    roots: ['<rootDir>/src'], // если тесты лежат в src/
  };
  