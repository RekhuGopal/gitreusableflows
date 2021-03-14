cd /home/ec2-user/SageMaker
aws s3 cp s3://fdsagemaker-bucket/fraud-detection-using-machine-learning/1.0/notebooks/sagemaker_fraud_detection.ipynb
sed -i 's/fraud-detection-end-to-end-demo/fdsagemaker-bucket/g' sagemaker_fraud_detection.ipynb