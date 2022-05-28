import * as cdk from 'aws-cdk-lib';
import * as cloudwatch from 'aws-cdk-lib/aws-cloudwatch';
import * as cwActions from 'aws-cdk-lib/aws-cloudwatch-actions';
import * as sns from 'aws-cdk-lib/aws-sns';
import * as snsSubscriptions from 'aws-cdk-lib/aws-sns-subscriptions';
import { Construct } from 'constructs';

/**
 * Sample stack for creating alarm. Creates alarm for DC case count.
 */
export class AlarmStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    const emails: string[] = JSON.parse(process.env.EMAILS!);

    const topic = new sns.Topic(this, 'Topic', {
      topicName: 'CovidPagerNotifications',
    });
    emails.forEach(emailAddress => {
      topic.addSubscription(new snsSubscriptions.EmailSubscription(emailAddress));
    });

    const dcCaseCountMetric = new cloudwatch.Metric({
      namespace: 'CovidPager',
      metricName: 'CaseCount',
      dimensionsMap: {
        State: 'DC',
      },
      period: cdk.Duration.days(1),
      statistic: 'Average',
    });

    const alarm = dcCaseCountMetric.createAlarm(this, 'DCCaseCountAlarm', {
      alarmDescription: 'DC Covid cases above 500',
      comparisonOperator: cloudwatch.ComparisonOperator.GREATER_THAN_THRESHOLD,
      threshold: 500,
      evaluationPeriods: 1,
    });
    alarm.addAlarmAction(new cwActions.SnsAction(topic));
  }
}