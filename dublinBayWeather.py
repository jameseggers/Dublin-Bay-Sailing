import tweepy
import json
import re
from pymongo import Connection
from tweepy import Stream
from tweepy import OAuthHandler
from tweepy.streaming import StreamListener


#unique authentication codes to access twitter api
ckey = 'pkCWTxTCX76fULhSSPZMeaOXp'
csecret = 'CQYW4iXTtM29yhtE6TL2ZWLYut33J3gGiftiE0WVHG7npuPFQw'
atoken = '321691375-uFP1WTIiRMNblmE2so8tNLrgYwFrB4v19wKXAOHt' 
asecret =  'wfJga59aQTQUHtYTJQDcu913hisjYYioKi0uE9Kg6JozB'

#authorisation handler
auth = OAuthHandler(ckey, csecret)
auth.set_access_token(atoken, asecret)

#access to api
api = tweepy.API(auth)

status_list = api.user_timeline('dublinbaybuoy',count = 1)
status = status_list[0]
#converts tweet to json then a dict
json_tweet = json.dumps(status._json)
tweet = json.loads(json_tweet)

with open('public/data/tweet.json', 'w') as outfile:
	json.dump(tweet, outfile)