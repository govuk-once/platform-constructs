import * as cdk from "aws-cdk-lib";
import { CodeRegistryStack } from "./code-registry.mts";
import { AwsSolutionsChecks, NIST80053R5Checks } from "cdk-nag";

const { App, Aspects } = cdk;

const app = new App();
new CodeRegistryStack(app, "RegistryPullThroughStack");
// Aspects.of(app).add(new AwsSolutionsChecks());
// Aspects.of(app).add(new NIST80053R5Checks());
