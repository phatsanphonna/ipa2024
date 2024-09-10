import requests
import json

access_token = ''
url = 'https://webexapis.com/v1/messages'
room_id = ''

headers = {
    'Authorization': 'Bearer {}'.format(access_token)
}
params = {
    'roomId': room_id,
    'max': 10
}

res = requests.get(url, headers=headers, params=params)
messages = json.loads(res.text)

for message in messages['items']:
    student_id = message['personEmail'].split('@')[0]
    text = message.get('text', 'send an attachment')
    print(f"{student_id}: {text}")
