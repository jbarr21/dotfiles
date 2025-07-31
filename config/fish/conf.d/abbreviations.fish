if type -q eza
  abbr -a ll 'eza -la'
  abbr -a lsl 'eza -l'
  abbr -a lsa 'eza -lah'
  abbr -a tree 'eza --tree'
end

if type -q trash
  abbr -a rm trash
end

abbr -a ".."    "cd .."
abbr -a "..."   "cd ../.."
abbr -a "...."  "cd ../../.."
abbr -a "....." "cd ../../../.."

# Git (from oh-my-zsh git plugin)
if type -q git
#  abbr -a grt cd "$(git rev-parse --show-toplevel || echo .)"
  abbr -a ggpur ggu
  abbr -a g git
  abbr -a ga git add
  abbr -a gaa git add --all
  abbr -a gapa git add --patch
  abbr -a gau git add --update
  abbr -a gav git add --verbose
#  abbr -a gwip git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign --message "--wip-- [skip ci]"
  abbr -a gam git am
  abbr -a gama git am --abort
  abbr -a gamc git am --continue
  abbr -a gamscp git am --show-current-patch
  abbr -a gams git am --skip
  abbr -a gap git apply
  abbr -a gapt git apply --3way
  abbr -a gbs git bisect
  abbr -a gbsb git bisect bad
  abbr -a gbsg git bisect good
  abbr -a gbsn git bisect new
  abbr -a gbso git bisect old
  abbr -a gbsr git bisect reset
  abbr -a gbss git bisect start
  abbr -a gbl git blame -w
  abbr -a gb git branch
  abbr -a gba git branch --all
  abbr -a gbd git branch --delete
  abbr -a gbD git branch --delete --force
#  abbr -a gbgd LANG=C git branch --no-color -vv | grep ": gone\]" | cut -c 3- | awk '"'"'{print $1}'"'"' | xargs git branch -d
#  abbr -a gbgD LANG=C git branch --no-color -vv | grep ": gone\]" | cut -c 3- | awk '"'"'{print $1}'"'"' | xargs git branch -D
  abbr -a gbm git branch --move
#  abbr -a gbnm git branch --no-merged
  abbr -a gbr git branch --remote
#  #abbr -a ggsup git branch --set-upstream-to=origin/$(git_current_branch)
#  abbr -a gbg LANG=C git branch -vv | grep ": gone\]"
  abbr -a gco git checkout
#  abbr -a gcor git checkout --recurse-submodules
#  abbr -a gcb git checkout -b
#  abbr -a gcB git checkout -B
#  #abbr -a gcd git checkout $(git_develop_branch)
#  #abbr -a gcm git checkout $(git_main_branch)
#  abbr -a gcp git cherry-pick
#  abbr -a gcpa git cherry-pick --abort
#  abbr -a gcpc git cherry-pick --continue
#  abbr -a gclean git clean --interactive -d
#  abbr -a gcl git clone --recurse-submodules
#  abbr -a gclf git clone --recursive --shallow-submodules --filter=blob:none --also-filter-submodules
#  abbr -a gcam git commit --all --message
#  abbr -a gcas git commit --all --signoff
#  abbr -a gcasm git commit --all --signoff --message
#  abbr -a gcs git commit --gpg-sign
#  abbr -a gcss git commit --gpg-sign --signoff
#  abbr -a gcssm git commit --gpg-sign --signoff --message
#  abbr -a gcmsg git commit --message
#  abbr -a gcsm git commit --signoff --message
  abbr -a gc git commit --verbose
  abbr -a gca git commit --verbose --all
#  abbr -a gca! git commit --verbose --all --amend
#  abbr -a gcan! git commit --verbose --all --no-edit --amend
#  abbr -a gcans! git commit --verbose --all --signoff --no-edit --amend
#  abbr -a gcann! git commit --verbose --all --date=now --no-edit --amend
#  abbr -a gc! git commit --verbose --amend
  abbr -a gcn git commit --verbose --no-edit
#  abbr -a gcn! git commit --verbose --no-edit --amend
#  abbr -a gcf git config --list
#  abbr -a gdct git describe --tags $(git rev-list --tags --max-count=1)
  abbr -a gd git diff
  abbr -a gdca git diff --cached
  abbr -a gdcw git diff --cached --word-diff
  abbr -a gds git diff --staged
  abbr -a gdw git diff --word-diff
#  abbr -a gdup git diff @{upstream}
  abbr -a gdt git diff-tree --no-commit-id --name-only -r
  abbr -a gf git fetch
  abbr -a gfo git fetch origin
  abbr -a gg git gui citool
  abbr -a gga git gui citool --amend
  abbr -a ghh git help
  abbr -a glgg git log --graph
  abbr -a glgga git log --graph --decorate --all
  abbr -a glgm git log --graph --max-count=10
  abbr -a glods git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset" --date=short
  abbr -a glod git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset"
  abbr -a glola git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --all
  abbr -a glols git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --stat
  abbr -a glol git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset"
  abbr -a glo git log --oneline --decorate
  abbr -a glog git log --oneline --decorate --graph
  abbr -a gloga git log --oneline --decorate --graph --all
#  abbr -a glp _git_log_prettily
  abbr -a glg git log --stat
  abbr -a glgp git log --stat --patch
#  abbr -a gignored git ls-files -v | grep "^[[:lower:]]"
#  abbr -a gfg git ls-files | grep
#  abbr -a gm git merge
#  abbr -a gma git merge --abort
#  abbr -a gmc git merge --continue
#  abbr -a gms="git merge --squash"
#  abbr -a gmff="git merge --ff-only"
#  #abbr -a gmom git merge origin/$(git_main_branch)
#  #abbr -a gmum git merge upstream/$(git_main_branch)
#  abbr -a gmtl git mergetool --no-prompt
#  abbr -a gmtlvim git mergetool --no-prompt --tool=vimdiff
  abbr -a gl git pull
  abbr -a gpr git pull --rebase
  abbr -a gprv git pull --rebase -v
  abbr -a gpra git pull --rebase --autostash
  abbr -a gprav git pull --rebase --autostash -v
#  #abbr -a gprom git pull --rebase origin $(git_main_branch)
#  #abbr -a gpromi git pull --rebase=interactive origin $(git_main_branch)
#  #abbr -a gprum git pull --rebase upstream $(git_main_branch)
#  #abbr -a gprumi git pull --rebase=interactive upstream $(git_main_branch)
#  #abbr -a ggpull git pull origin "$(git_current_branch)"
#  #abbr -a gluc git pull upstream $(git_current_branch)
#  #abbr -a glum git pull upstream $(git_main_branch)
  abbr -a gp git push
  abbr -a gpd git push --dry-run
#  abbr -a gpf! git push --force
#  #abbr -a gpsup git push --set-upstream origin $(git_current_branch)
#  abbr -a gpv git push --verbose
#  abbr -a gpoat git push origin --all && git push origin --tags
#  abbr -a gpod git push origin --delete
#  #abbr -a ggpush git push origin "$(git_current_branch)"
  abbr -a gpu git push upstream
  abbr -a grb git rebase
  abbr -a grba git rebase --abort
  abbr -a grbc git rebase --continue
  abbr -a grbi git rebase --interactive
  abbr -a grbo git rebase --onto
  abbr -a grbs git rebase --skip
#  #abbr -a grbd git rebase $(git_develop_branch)
#  #abbr -a grbm git rebase $(git_main_branch)
#  #abbr -a grbom git rebase origin/$(git_main_branch)
#  #abbr -a grbum git rebase upstream/$(git_main_branch)
#  abbr -a grf git reflog
  abbr -a gr git remote
  abbr -a grv git remote --verbose
  abbr -a gra git remote add
  abbr -a grrm git remote remove
  abbr -a grmv git remote rename
  abbr -a grset git remote set-url
  abbr -a grup git remote update
  abbr -a grh git reset
  abbr -a gru git reset --
  abbr -a grhh git reset --hard
  abbr -a grhk git reset --keep
  abbr -a grhs git reset --soft
#  abbr -a gpristine git reset --hard && git clean --force -dfx
#  abbr -a gwipe git reset --hard && git clean --force -df
#  #abbr -a groh git reset origin/$(git_current_branch) --hard
#  abbr -a grs git restore
#  abbr -a grss git restore --source
#  abbr -a grst git restore --staged
#  abbr -a gunwip git rev-list --max-count=1 --format="%s" HEAD | grep -q "\--wip--" && git reset HEAD~1
#  abbr -a grev git revert
#  abbr -a greva git revert --abort
#  abbr -a grevc git revert --continue
#  abbr -a grm git rm
#  abbr -a grmc git rm --cached
#  abbr -a gcount git shortlog --summary --numbered
  abbr -a gsh git show
  abbr -a gsps git show --pretty=short --show-signature
  abbr -a gstall git stash --all
  abbr -a gstaa git stash apply
  abbr -a gstc git stash clear
  abbr -a gstd git stash drop
  abbr -a gstl git stash list
  abbr -a gstp git stash pop
  abbr -a gsts git stash show --patch
  abbr -a gst git status
  abbr -a gss git status --short
  abbr -a gsb git status --short --branch
#  abbr -a gsi git submodule init
#  abbr -a gsu git submodule update
#  abbr -a gsd git svn dcommit
#  #abbr -a git-svn-dcommit-push git svn dcommit && git push github $(git_main_branch):svntrunk
#  abbr -a gsr git svn rebase
#  abbr -a gsw git switch
#  abbr -a gswc git switch --create
#  #abbr -a gswd git switch $(git_develop_branch)
#  #abbr -a gswm git switch $(git_main_branch)
#  abbr -a gta git tag --annotate
#  abbr -a gts git tag --sign
#  abbr -a gtv git tag | sort -V
#  abbr -a gignore git update-index --assume-unchanged
#  abbr -a gunignore git update-index --no-assume-unchanged
#  abbr -a gwch git whatchanged -p --abbrev-commit --pretty=medium
#  abbr -a gwt git worktree
#  abbr -a gwta git worktree add
#  abbr -a gwtls git worktree list
#  abbr -a gwtmv git worktree move
#  abbr -a gwtrm git worktree remove
#  abbr -a gstu gsta --include-untracked
#  #abbr -a gtl gtl(){ git tag --sort=-v:refname -n --list "$1*" }; noglob gtl
#  #abbr -a gk \gitk --all --branches &!
#  #abbr -a gke \gitk --all $(git log --walk-reflogs --pretty=%h) &!
end

