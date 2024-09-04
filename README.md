# devops-r-d
Learning DevOps practises

1. Create repositiry devops-r-d
2. Push the script return.py
3. Create branch feature-1
4. Change script return and README.md
5. Push changes
6. Merge feature-1 branch and master with next commands
-git checkout master
-git merge feature-1
-git push origin master
got below output:
vladv@vvovk-lp:~/devops/devops-r-d$ git merge feature-1
Updating ba30e42..e30ab3a
Fast-forward
 README.md | 8 ++++++--
 return.py | 9 +++------
 2 files changed, 9 insertions(+), 8 deletions(-)
vladv@vvovk-lp:~/devops/devops-r-d$ git push origin master
Total 0 (delta 0), reused 0 (delta 0)
To github.com:volkajaizier/devops-r-d.git
   ba30e42..e30ab3a  master -> master
7. Create feature-2 branch
8. Add script repeater.py
9. Push changes to feature-2 branch