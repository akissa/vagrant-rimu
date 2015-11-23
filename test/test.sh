#!/usr/bin/env bash

cd test

bundle exec vagrant up --provider=rimu
bundle exec vagrant up
bundle exec vagrant provision
bundle exec vagrant rebuild
bundle exec vagrant halt
bundle exec vagrant destroy

cd -
