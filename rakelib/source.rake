#!/usr/bin/env ruby

namespace :source do

  desc "Source : Change"
  task :change, [:branchname] do | t, args |

    ENV['SOURCE_REPO_URL'] = 'git@github.com:RayPatterson/project-boilerplate-source.git'
    ENV['SOURCE_REPO_ALIAS'] = 'source'
    ENV['SOURCE_REPO_BRANCH'] = args.branchname

    sh %{
      git ls-remote $SOURCE_REPO_URL &>-
      if [ "$?" -ne 0 ]; then
          echo "Adding remote '$SOURCE_REPO_ALIAS'"

          git remote add source git@github.com:RayPatterson/project-boilerplate-source.git

      else
          echo "Remote '$SOURCE_REPO_ALIAS' already added"

          for branch in `git branch -a | grep remotes | grep -v HEAD | grep -v origin | grep -v master`; do
              git branch --track $SOURCE_REPO_ALIAS-${branch##*/} $branch
          done
      fi

      git rm -r $SOURCE_REPO_ALIAS
      git add -A
      git commit -m "Removed $SOURCE_REPO_ALIAS files."
      git read-tree --prefix=$SOURCE_REPO_ALIAS/ -u $SOURCE_REPO_ALIAS-$SOURCE_REPO_BRANCH
    }

  end

end
