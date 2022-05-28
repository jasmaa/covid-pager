#!/usr/bin/env node
import 'dotenv/config';
import * as cdk from 'aws-cdk-lib';
import { DeploymentStack } from '../lib/deployment-stack';
import { AlarmStack } from '../lib/alarm-stack';

const app = new cdk.App();
new DeploymentStack(app, 'DeploymentStack');
new AlarmStack(app, 'AlarmStack')