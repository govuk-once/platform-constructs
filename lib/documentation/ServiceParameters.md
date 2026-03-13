# ServiceParameters

## Description

The `ServiceParameters` class acts as a centralized data accessor for shared infrastructure parameters stored in AWS Systems Manager (SSM) Parameter Store. It simplifies the retrieval of DNS and SSL/TLS certificate configurations, such as Route53 Hosted Zone details and ACM Certificate ARNs.

The class uses a lazy-loading (caching) pattern to ensure that parameters are only looked up once within the CDK synth process, preventing duplicate resource lookups in the same stack.

## Constructor

The constructor initializes the class with a CDK scope.

| **Parameter Name** | **Type** | **Function** | **Required** |
| --- | --- | --- | --- |
| scope | Construct | The stack scope where the SSM parameters and resource lookups will be associated | YES |

**Returns**: ServiceParameters

---

## Methods

### hostedZoneName

Retrieves the name of the hosted zone from the SSM parameter path `/infra/dns/hostedzonename`.

**Returns**: `string`

### hostedZoneId

Retrieves the unique ID of the hosted zone from the SSM parameter path `/infra/dns/hostedzoneid`.

**Returns**: `string`

### acmCertArn

Retrieves the regional ACM Certificate ARN from the SSM parameter path `/infra/acm/certificatearnregional`.

**Returns**: `cdk.aws_ssm.IStringParameter`

### zone

Returns a Route53 `IHostedZone` object by combining the name and ID retrieved from SSM. This is useful for adding DNS records (A, CNAME, etc.) to an existing zone.

**Returns**: `cdk.aws_route53.IHostedZone`

### certificate

Returns an ACM `ICertificate` object using the ARN retrieved from SSM. This object can be directly passed to resources like Load Balancers or CloudFront distributions.

**Returns**: `ICertificate`

---

## Internal Parameter Mappings

This class expects the following keys to exist in your AWS SSM Parameter Store:

| **SSM Parameter Name** | **Description** |
| --- | --- |
| `/infra/dns/hostedzonename` | The domain name (e.g., example.com) |
| `/infra/dns/hostedzoneid` | The Route53 Hosted Zone ID |
| `/infra/acm/certificatearnregional` | The ARN of the ACM certificate for the region |

---

## Example

### Using Parameters in a Stack

```typescript
import { ServiceParameters } from './parameters/ServiceParameters';

const params = new ServiceParameters(this);

// Access raw values
const domain = params.hostedZoneName();

// Access CDK resource objects
const zone = params.zone();
const cert = params.certificate();

// Use in another factory
new MyWebDistribution(this, 'Web', {
  hostedZone: zone,
  certificate: cert
});
```
## Known Issues
