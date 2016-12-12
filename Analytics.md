# Docker-selenium's Anonymous Aggregate User Behaviour Analytics
Docker-selenium has begun gathering anonymous aggregate user behaviour analytics and reporting these to Google Analytics. You are notified about this when you start and stop Docker-selenium.

## Why?
Docker-selenium is provided free of charge and we don't have direct communication with its users nor time resources to ask directly for their feedback. As a result, we now use anonymous aggregate user analytics to help us understand how Docker-selenium is being used, the most common used features based on how, where and when people use it. With this information we can prioritize some features over other ones, understand better which Selenium or Docker versions we should support depending on the usage, and get execution exceptions to identify bugs.

## What?
Docker-selenium's analytics record some shared information for every event:

- The Google Analytics version i.e. `1` (https://developers.google.com/analytics/devguides/collection/protocol/v1/parameters#v)
- The Docker-selenium analytics tracking ID e.g. `UA-18144954-9` (https://developers.google.com/analytics/devguides/collection/protocol/v1/parameters#tid)
- The Google Analytics anonymous IP setting is enabled i.e. `1` (https://developers.google.com/analytics/devguides/collection/protocol/v1/parameters#aip)
- The Docker-selenium application name e.g. `dosel` (https://developers.google.com/analytics/devguides/collection/protocol/v1/parameters#an)
- The Docker-selenium application version e.g. `3.0.1-p0` (https://developers.google.com/analytics/devguides/collection/protocol/v1/parameters#av)
- The Docker-selenium analytics hit type e.g. `screenview` (https://developers.google.com/analytics/devguides/collection/protocol/v1/parameters#t)

Docker-selenium's analytics records the following different events:

- a `screenview` when you start Docker-selenium and the options you used to start it. Users and API keys for the cloud testing providers are never recorded.
- an `event` hit type with the `test_start` event category from the capabilities as event label.
- an `event` hit type with the `test_stop` event category from the capabilities as event label.
- an `exception` hit type with the `exception` event category, exception description of the exception name and whether the exception was fatal e.g. `1`

With the recorded information, it is not possible for us to match any particular real user.

As far as we can tell it would be impossible for Google to match the randomly generated analytics user ID to any other Google Analytics user ID. If Google turned evil (by being hacked for example) the only thing they could do would be to lie about anonymising IP addresses and attempt to match users based on IP addresses.

## When/Where?
Docker-selenium's analytics are sent throughout Docker-selenium's execution to Google Analytics over HTTPS.

## Who?
Docker-selenium's analytics are accessible to Docker-selenium's current maintainers. Contact [@elgalu](https://github.com/elgalu) if you are a maintainer and need access.

## How?
The code is viewable in:
* [Docker-selenium start](./scripts/dosel.sh#L267)
* [Docker-selenium stop](./scripts/dosel.sh#L98)
* [Start, stop tests and exceptions](./src/main/java/de/elgalu/tip/dosel/util/GoogleAnalyticsApi.java)

The code is implemented so it gets executed in a background process, without delaying normal execution. If it fails, it will do it immediately and silently.

## Opting out before starting Docker-selenium
Docker-selenium analytics helps us maintainers and leaving it on is appreciated. However, if you want to opt out and not send any information, you can do this by using passing the following parameter at docker run time:

```sh
-e SEND_ANONYMOUS_USAGE_INFO=false
```

## Disclaimer
This document and the implementation are based on the great idea implemented by [Homebrew](https://github.com/Homebrew/brew/blob/master/docs/Analytics.md)
