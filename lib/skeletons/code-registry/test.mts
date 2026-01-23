import { App, Aspects } from "aws-cdk-lib";
import { CodeRegistryStack } from "./code-registry.mjs";
import { AwsSolutionsChecks, NIST80053R5Checks } from "cdk-nag";

const app = new App();
new CodeRegistryStack(app, "NagCodeRegistry");
// Simple rule informational messages using the AWS Solutions Rule pack
Aspects.of(app).add(new AwsSolutionsChecks());
// Multiple rule packs can be run against the same app
Aspects.of(app).add(new NIST80053R5Checks());
// Additional explanations on the purpose of triggered rules
// Aspects.of(stack).add(new AwsSolutionsChecks({ verbose: true }));
