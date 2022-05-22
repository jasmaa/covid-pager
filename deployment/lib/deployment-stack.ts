import * as path from 'path';
import * as cdk from 'aws-cdk-lib';
import * as lambda from 'aws-cdk-lib/aws-lambda';
import { Construct } from 'constructs';

export class DeploymentStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    const fn = new lambda.DockerImageFunction(this, 'ECRFunction', {
      functionName: 'CovidPager',
      code: lambda.DockerImageCode.fromImageAsset('..'),
      timeout: cdk.Duration.seconds(30),
    });
  }
}
