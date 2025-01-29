1.Create Dynamodb in AWS console
2.Add data with batch.json file and command
vladv@vvovk-lp:~/devops/devops-r-d/lecture-37$ aws dynamodb batch-write-item --request-items file://batch.json
{
    "UnprocessedItems": {}
}
vladv@vvovk-lp:~/devops/devops-r-d/lecture-37$ aws dynamodb scan --table-name lecture-37
{
    "Items": [
        {
            "phoneNumber": {
                "S": "+1-123-456-7890"
            },
            "email": {
                "S": "user@example.com"
            },
            "name": {
                "S": "John Doe"
            },
            "userId": {
                "S": "u12345"
            }
        },

2. Enable stream
![alt text](Dynamo-stream.png)
3.Create Lambda function and add trigger
![alt text](image-1.png)

4. add python code 
![alt text](image.png)

5. deploy it and create a new test event
![alt text](image-2.png)

6. test event succeded
![alt text](image-3.png)
and mail received
![alt text](image-4.png)