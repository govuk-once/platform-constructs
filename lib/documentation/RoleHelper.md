# RoleHelper

## Description

The `RoleHelper` provides a simplified way to manage IAM permissions for Lambda functions accessing DynamoDB tables and S3 buckets. It automatically maps high-level CRUD operations (Create, Read, Update, Delete) to the specific IAM actions required for those services. Additionally, it handles KMS key grants for encrypted DynamoDB tables and ensures that Lambda functions have the necessary execution roles.

## Constructor

The constructor initializes the helper with a scope and a naming provider.

| **Parameter Name** | **Type** | **Function** | **Required** |
| --- | --- | --- | --- |
| scope | Construct | The stack scope where the role or policies will be created | YES |
| serviceName | String | The name of the service used for default naming | YES |
| namingProvider | INamingProvider | Custom naming strategy. Defaults to `ServiceEnvironmentNamingProvider` | NO |

**Returns**: RoleHelper

---

## Methods

### addDynamoOperationPermissionsToLambda

Grants a Lambda function specific permissions to a DynamoDB table and its indexes. It also automatically detects and grants permissions for the table's KMS encryption key if one exists.

| **Parameter Name** | **Type** | **Function** | **Required** |
| --- | --- | --- | --- |
| props | [IRoleHelperProps](#IRoleHelperProps) | Configuration including the lambda, table, and operations | YES |

**Returns**: iam.Role

### addS3OperationPermissionsToLambda

Grants a Lambda function specific permissions to an S3 bucket and its objects. It distinguishes between bucket-level actions (like `ListBucket`) and object-level actions (like `GetObject`).

| **Parameter Name** | **Type** | **Function** | **Required** |
| --- | --- | --- | --- |
| props | [IRoleHelperProps](#IRoleHelperProps) | Configuration including the lambda, bucket, and operations | YES |

**Returns**: iam.Role

---

## Enums and Interfaces

### Operations (Enum)
Defines high-level resource interactions:
* `CREATE`
* `READ`
* `UPDATE`
* `DELETE`

### IRoleHelperProps

| **Parameter Name** | **Type** | **Function** | **Required** |
| --- | --- | --- | --- |
| id | string | Unique identifier for the role (if a new one is created) | YES |
| lambda | lambda.IFunction | The Lambda function receiving the permissions | YES |
| operations | Operations[] | Array of CRUD operations to permit | YES |
| table | dynamodb.ITable | The target DynamoDB table | NO* |
| bucket | s3.IBucket | The target S3 bucket | NO* |
| role | iam.Role | An optional existing role to attach policies to | NO |

*\*Note: `table` is required for DynamoDB methods; `bucket` is required for S3 methods.*

---

## Example

### Granting Read/Write access to a Table

```typescript
import { RoleHelper, Operations } from "./helpers/RoleHelper";

const helper = new RoleHelper(stack, "OrderService");

helper.addDynamoOperationPermissionsToLambda({
  id: "OrderTableAccess",
  lambda: myLambda,
  table: myTable,
  operations: [Operations.CREATE, Operations.READ]
});
```
## Known Issues
