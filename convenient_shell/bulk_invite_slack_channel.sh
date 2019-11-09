#!/bin/sh
slacktoken=xoxp-NNNNNNNNNNN-NNNNNNNNNNNN-NNNNNNNNNN-XXXXXXXXXXXXXXXXXXXXXX
channel=XXXYYYZZZ
members=`cat $1`
for u in $members; do
  echo Inviting user $u;
  slack_user_id=`curl -H 'Content-Type: application/x-www-form-urlencoded' "https://slack.com/api/users.lookupByEmail" -d "token=$slacktoken&email=$u" | jq -r '.user.id'`
  curl -X POST -H "Authorization: Bearer $slacktoken" -H 'Content-Type: application/x-www-form-urlencoded' -i "https://slack.com/api/channels.invite" -d "channel=$channel&user=$slack_user_id";
  sleep 2;
done;
