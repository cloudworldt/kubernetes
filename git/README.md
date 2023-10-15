# Before Git:

![business](https://github.com/rizwan141/KUBERNETES/assets/103893307/ef4d6940-dec4-4f49-a15f-a6f59a350fce)

- Developers used to submit their codes to the central server without having copies of their own
- Any changes made to the source code were unknown to the other developers
- There was no communication between any of the developers

# After Git:

![business-org](https://github.com/rizwan141/KUBERNETES/assets/103893307/5ca81cb1-ed54-4d87-a04f-5a3643319edb)

- Every developer has an entire copy of the code on their local systems
- Any changes made to the source code can be tracked by others
- There is regular communication between the developers




# git

Git is an open-source distributed version control system. It is designed to handle minor to major projects with high speed and efficiency. It is developed to co-ordinate the work among the developers. The version control allows us to track and work together with our team members at the same workspace.

<img width="588" alt="Screenshot 2023-07-14 at 5 42 37 PM" src="https://github.com/rizwan141/KUBERNETES/assets/103893307/7802986b-2214-424b-b612-9e92e558c5c1">

- Git is used to tracking changes in the source code
- The distributed version control tool is used for source code management
- It allows multiple developers to work together


# github

GitHub is a Git repository hosting service that provides a web-based graphical interface (GUI). It helps every team member work together on a project from anywhere, making it easy to collaborate. 

GitHub is one place where project managers and developers coordinate, track, and update their work,


## Git Workflow

### The Git workflow is divided into three states:

`Working directory` - Modify files in your working directory \
`Staging area (Index)` - Stage the files and add snapshots of them to your staging area \
`Git directory (Repository)` - Perform a commit that stores the snapshots permanently to your Git directory

### Install Git
```
sudo apt update
sudo apt install git
git --version
```

#### Set up global config variables - If you are working with other developers, you need to know who is checking the code in and out, and to make the changes.
```
git config --global user.name "Rizwan Shaikh"

git config --global user.email rizwanshaikh123@gmail.com

git config –list
```
## Demo

### developer-1  wants to create code on his local 

```sql
mkdir git-demo # create directory

cd demo # enter the dir

git init # initializing git repo

ls -al # check .git directory (history will store in this directory)

touch test.txt # create one file

git status # you can see untracked files

git add test.txt # put file in staging area

git status # file is tracked now

git commit -m "added test.txt file" # save in git history (-m statnds for provide a msg)

git status # nothing to commit

vi test.txt # add something

git status # fils is modified

git add . # added to stage

git restore --staged test.txt  # remove from stage without commeting it

git add . \
git commit -m "added lines in test.txt" # again add and commit the file

git status # check insertations and output

git log # check the history

rm -rf test.txt  # delete the file and again do git add and commit

git log # you can see delete history is there but you want to clean from history

git reset <##########################> # use hash values .... whatever commit you copied it will delete above ones

git log # now you can see that comment which you want to keep

git status # now delete history is in unstage area

# create some more files and add them to stage area.... now you dont want this files in stage area and you dont want to loose this changes. but later you will need this files 
git stash

# use git status and log command to see everything is back to previous step

# now you want bring back those files which you stash

git stash pop # files will back in stage area again

git stash clear # if you dont want those files 

```

### developer-1  Wants to share his project to others ?

```sql
create a repo on github
attached newly created repo to your project ---> git remote add origin <repo url> i.e local and repo is connected with each other 
how many urls attached to your project -----> git remote -v
push the changes in repo  ----->  git push origin master
```

### developer-1  will use Branching Strategy

![155993572204-gitflow](https://github.com/rizwan141/KUBERNETES/assets/103893307/399b9105-898b-41e0-8960-b3544c2a4286)


Branches are primarily used as a means for teams to develop features giving them a separate workspace for their code. These branches are usually merged back to a master branch upon completion of work. In this way, features (and any bug and bug fixes) are kept apart from each other allowing you to fix mistakes more easily.

Branching is one of the most useful concepts of Git world. Developers create a lot of branches like:

Example :~

**master or main:** The master or main branch is by default branch provided by Git. \
**development:** The development branch is created by developers for the development process. \
**testing:** The testing or test branch is created by the developer to perform testing-related operations. \
**feature:** The feature branch is created by the developers to add new features to the ongoing project.


- developer-1 can not push code directly on main/master branch
- coz code is not finalized yet
- along with developer-1 there are some other developers as well whoes are going to contribute to this project

```sql
git branch feature # create new branch feature
git checkout feature # change branch to feature
git merge feature # now code is finalized so we can merged into main/master so that other people can use the same
git pull origin master # to pull the latest code on your local
```


### [Cheatsheet](https://education.github.com/git-cheat-sheet-education.pdf)

