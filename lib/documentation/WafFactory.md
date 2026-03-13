# Waf Factory

## Description

The `WafFactory` simplifies the creation of AWS WAFv2 Web ACLs for both CloudFront distributions and regional resources (like Application Load Balancers or API Gateways). It provides a high-level interface to implement security best practices, including managed rule sets, rate limiting, and custom rules, while ensuring standardized naming through a naming provider.



## Constructor

The constructor initializes the factory with the required scope and naming context.

| **Parameter Name** | **Type** | **Function** | **Required** |
| --- | --- | --- | --- |
| scope | Construct | The stack scope where the Web ACL will be created | YES |
| serviceName | String | The name of the service used for resource naming | YES |
| namingProvider | INamingProvider | Custom naming strategy for identifiers | NO |

**Returns**: WafFactory

---

## Methods

### createWebAcl

Creates a `CfnWebACL` resource with a set of default or custom managed rules, optional rate limiting, and visibility configurations for CloudWatch.

| **Parameter Name** | **Type** | **Function** | **Required** |
| --- | --- | --- | --- |
| id | String | Unique identifier for the WAF construct | YES |
| props | [IWafProperties](#IWafProperties) | Configuration settings for the Web ACL | YES |

**Returns**: waf.CfnWebACL

---

## Interfaces

### IWafProperties

| **Parameter Name** | **Type** | **Function** | **Required** |
| --- | --- | --- | --- |
| scope | 'CLOUDFRONT' \| 'REGIONAL' | Specifies if the WAF is for CloudFront or regional resources | YES |
| name | String | The base name for the Web ACL | YES |
| defaultAction | 'ALLOW' \| 'BLOCK' | Action to take if no rules match (Defaults to ALLOW) | NO |
| managedRuleGroups | Array | List of managed rules to apply | NO* |
| rateLimit | Object | Configuration for IP-based rate limiting | NO |
| metricName | String | Custom name for CloudWatch metrics | NO |
| customRules | RuleProperty[] | Additional low-level WAF rules | NO |

*\*Note: If `managedRuleGroups` is not provided, the factory applies a default set of AWS Managed Rules (Common, Known Bad Inputs, SQLi, and IP Reputation).*

---

## Default Managed Rules

If no rule groups are specified, the factory automatically includes:
1. **AWSManagedRulesCommonRuleSet** (Priority 20)
2. **AWSManagedRulesKnownBadInputsRuleSet** (Priority 30)
3. **AWSManagedRulesSQLiSet** (Priority 40)
4. **AWSManagedRulesAmazonIpReputationList** (Priority 50)

---

## Example

### Creating a WAF for a Regional API

```typescript
import { WafFactory } from './factories/WafFactory';

const wafFactory = new WafFactory(this, "SecurityService");

const webAcl = wafFactory.createWebAcl("ApiWaf", {
  name: "MainApiFirewall",
  scope: "REGIONAL",
  rateLimit: {
    limit: 1000,
    priority: 10,
    action: "BLOCK"
  }
});
```
## Known Issues