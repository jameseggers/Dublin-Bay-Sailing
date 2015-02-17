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
text = tweet["text"]

#creates a map of floats from numbers in the text using regular expressions
m = map(float, re.findall(r'[-+]?[0-9]*\.?[0-9]', text))

#setup db
con = Connection()
#creates database if it doesnt exist
db = con.weather_database

stats= db.stats

stats.insert({'avg_wind': m[0], 'gust':m[1], 'wind_dir':m[2],
	'wave_height':m[3],'wave_period':m[4],'water_temp':[5],
	'day':m[6],'month':m[7],'year':m[8],'hour':m[9],
	'minute':m[10],'second':m[11]})
collection = stats.find()
for stat in collection:
	print stat


