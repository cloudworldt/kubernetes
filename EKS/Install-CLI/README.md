### Install the `AWS CLI` : <a href="https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html">Docs</a>
```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
apt install unzip
unzip awscliv2.zip
sudo ./aws/install
aws --version
```
<img width="708" alt="Screenshot 2022-12-22 at 12 07 08 PM" src="https://user-images.githubusercontent.com/103893307/209091728-43e0232f-fc53-4e32-9b32-e134494fd1b6.png">

### Installing `kubectl` : <a href="https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html">Docs</a>
```
curl -o kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/1.24.7/2022-10-31/bin/linux/amd64/kubectl
```
```
chmod +x ./kubectl
```
```
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
```
```
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
```
```
kubectl version --short --client
```
<img width="1025" alt="Screenshot 2022-12-22 at 1 50 03 PM" src="https://user-images.githubusercontent.com/103893307/209091884-f6031734-bf69-473f-892f-2a75df9ea57b.png">

### Installing `eksctl` : <a href="https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html#installing-eksctl">Docs</a>
```
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
```
```
sudo mv /tmp/eksctl /usr/local/bin
```
```
eksctl version
```
<img width="390" alt="Screenshot 2022-12-22 at 1 52 02 PM" src="https://user-images.githubusercontent.com/103893307/209092048-e91c348d-7a97-47b6-80fe-75a3173ec738.png">

### Configure AWS Command Line using Security Credentials
- Go to AWS Management Console --> Services --> IAM
- Select the IAM User: <your_iam_user_name>
- **Important Note:** Use only IAM user to generate **Security Credentials**. Never ever use Root User. (Highly not recommended)
- Click on **Security credentials** tab
- Click on **Create access key**
- Copy Access ID and Secret access key
- Go to command line and provide the required details

```
aws configure
AWS Access Key ID [None]: XXXXXXXXXXXXXXXXXX  (Replace your creds when prompted)
AWS Secret Access Key [None]: XXXXXXXXXXXXXXXXXXXXXXXXXXX  (Replace your creds when prompted)
Default region name [None]: us-east-1
Default output format [None]: json
```
- Test if AWS CLI is working after configuring the above
```
aws ec2 describe-vpcs
```
<img width="779" alt="Screenshot 2022-12-22 at 12 44 15 PM" src="https://user-images.githubusercontent.com/103893307/209093391-412dc3bc-f6f4-40b3-a43e-bd78f926d218.png">
