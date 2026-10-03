console.log(
  "Pi Durable adapter placeholder. No agents or automations deployed."
);
if (process.argv.includes("--deploy")) {
  console.error(
    "Deployment unavailable: Pi Durable integration is not implemented."
  );
  process.exitCode = 1;
}
