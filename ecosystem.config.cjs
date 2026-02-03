module.exports = {
  apps: [
    {
      name: "ansvue",
      script: "npm",
      args: "run dev -- --host 0.0.0.0 --port 5173",
      cwd: __dirname,
      env: { NODE_ENV: "development" }
    }
  ]
}