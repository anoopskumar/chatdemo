// npm install axios
const axios = require('axios');

const token = 'ya29.c.c0ASRK0GaClFMHf_9BXfIaUS4DeHAAuPjXyOxsQPg-7OQuAie0tLThufFWXBDeFPJOkd-D-mtxHMjTqE1m2xGMwhlmUyT71F2ImI_tKTAq-Z7W7a97H33avk2RiGY4E6yh39aRxAZpMwHgR0-7T6q-zh5iSItrum5Sfronn0HD4JBMX44JfPITdASCWqYQ98Z-84LTgLYIV5pImBI8Yv8Zn_iVZbDWS8FrHW3N3XfT4L-RJ2lX6E9oadwJ9xsJiYRNdQkNYQmp4nTO5Ue5odppM6vv5w2oUeuj83UHa2U2lHJKCS1QU5i1NYJPOVFLNur_xl7tuMq-szC3aa2brCKxXj3wOKCzBpnyq7XET-fJn6ixk4aOG8DBi_mOL385Pci2Sl0ds_YOroRkXZyqMo3z4zyf8vi8yF7rc05qrvVW6ugn4oOhyxh-cj_vWbnFgynMsnrz5ghb39h7_k6xB_uFMkeuQUqFBsnMIsWkXYjuvdzvewpM_zMWc--RMsVaFlIOQXomYtiYQ6p9Utw4II1p-S1V6B56479x1slqi6fJ4jhcQlSBri4Wl5vXqnnwlccbO6fg9cQgfUZx0UmhxBja_2hmfk2d6jXlROV5Q4hqnb6ZJzgkj0lQvOX8gF5xQ_yQ6i-9ef36bcwZni16OWRuZ7_wBcxI5n02-iFS8XkSFpquQq208ZWBor3dRM9ZxYSdJlRksj2Yoq7sfRzqMFXwuiXl61pRWYF0yU4rz3bWS1asu5yBoaWneIfQ5nf4hcQQ9lB_bb_QVo6re-p0h0JQagxvovkM4U075Zkrmzi32aemksb4kFsk4Ziumu9ovJt0-f95uJj1tdp8pr1Vm2ur3RIyuvZlqlt9FxJOQdR7kWt5jjkrReWhw4e9ghvQnMweIatV9xd3SBzW_pv7c9p9wS7FB5me79hoyZa0mVRxcF151v4IIqsMeJOBtoc0MxtezSt4dyprQvFvWB1MM4p1h_8cuvsgrb-pWicFu6o728cXsRdOttVVxwx'; // Replace with your generated token

const url = 'https://fcm.googleapis.com/v1/projects/chat-app-a309b/messages:send';

const messagePayload = {
  message: {
    topic: "all_devices",
    notification: {
      title: "Broadcast Notification",
      body: "This message is sent to all devices!"
    },
    data: {
      type: "chat" // Used for navigation
    },
    android: {
      priority: "high",
      notification: {
        channel_id: "high_importance_channel"
      }
    }
  }
};

const headers = {
  'Authorization': `Bearer ${token}`,
  'Content-Type': 'application/json'
};

axios.post(url, messagePayload, { headers })
  .then(response => {
    console.log('Message sent successfully:', response.data);
  })
  .catch(error => {
    console.error('Error sending message:', error.response ? error.response.data : error.message);
  });