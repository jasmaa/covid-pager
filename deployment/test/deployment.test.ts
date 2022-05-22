import * as cdk from 'aws-cdk-lib';
import { Template, Match } from 'aws-cdk-lib/assertions';
import * as Deployment from '../lib/deployment-stack';

test('Covid pager function is created', () => {
  const app = new cdk.App();
  // WHEN
  const stack = new Deployment.DeploymentStack(app, 'MyTestStack');
  // THEN

  const template = Template.fromStack(stack);

  template.hasResourceProperties('AWS::Lambda::Function', {
    FunctionName: 'CovidPager'
  });

  template.hasResourceProperties('AWS::IAM::Policy', {
    "PolicyDocument": {
      "Statement": [
        {
          "Action": "cloudwatch:PutMetricData",
          "Effect": "Allow",
          "Resource": "*"
        }
      ],
    },
  });
});
