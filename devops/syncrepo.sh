#!/bin/bash

git clone --single-branch --branch staging git@github.com:WAYA-MULTI-LINK/WAYA-PAY-CHAT-2.0-WAYAGRAM-FLUTTER-APP.git
cd WAYA-PAY-CHAT-2.0-WAYAGRAM-FLUTTER-APP
git branch -m wayagram_staging
git remote add wayagram_staging git@github.com:WAYA-MULTI-LINK/WAYA-PAY-CHAT-2.0-FLUTTER-SUPERAPP-AGGREGATOR.git
git push -u wayagram_staging
git push --tags -u wayagram_staging

cd ..

rm -r WAYA-PAY-CHAT-2.0-WAYAGRAM-FLUTTER-APP


 git clone --single-branch --branch production git@github.com:WAYA-MULTI-LINK/WAYA-PAY-CHAT-2.0-WAYAGRAM-FLUTTER-APP.git
 cd WAYA-PAY-CHAT-2.0-WAYAGRAM-FLUTTER-APP
 git branch -m wayagram_production
 git remote add wayagram_production git@github.com:WAYA-MULTI-LINK/WAYA-PAY-CHAT-2.0-FLUTTER-SUPERAPP-AGGREGATOR.git
 git push -u wayagram_production
 git push --tags -u wayagram_production

 cd ..

 rm -r WAYA-PAY-CHAT-2.0-WAYAGRAM-FLUTTER-APP
