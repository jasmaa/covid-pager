import * as cdk from 'aws-cdk-lib';
import * as iam from 'aws-cdk-lib/aws-iam';
import * as lambda from 'aws-cdk-lib/aws-lambda';
import * as events from 'aws-cdk-lib/aws-events';
import * as targets from 'aws-cdk-lib/aws-events-targets';
import { Construct } from 'constructs';

export class DeploymentStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    const fn = new lambda.DockerImageFunction(this, 'ECRFunction', {
      functionName: 'CovidPager',
      code: lambda.DockerImageCode.fromImageAsset('..'),
      timeout: cdk.Duration.seconds(30),
    });

    fn.role?.attachInlinePolicy(new iam.Policy(this, 'FunctionPolicy', {
      statements: [
        new iam.PolicyStatement({
          actions: ['cloudwatch:PutMetricData'],
          resources: ['*']
        }),
      ]
    }));

    const rule = new events.Rule(this, 'ScheduleRule', {
      schedule: events.Schedule.cron({ minute: '0', hour: '8' }),
      targets: [new targets.LambdaFunction(fn)],
    });
  }
}
