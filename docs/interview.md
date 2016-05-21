### Interview

A few days ago [Lauri Apple][lauri] and [Raffaele Di Fazio][raffo] approached me with a few interesting questions about [docker-selenium][] that we decided to share here.

<h4 id="WHAT">What is the project about?</h4>

The project aims to provide [Selenium][] inside a [docker][] container.

<h4 id="HOW">How did the project get started? Under what conditions/after what happened?</h4>

The project started while I was in charge of building and maintaining the test automation suite of an [AngularJS][] project at [AppNexus][]. I was also doing DevOps tasks related to the test infrastructure.

The objective was to run the tests headless, different solutions existed for that and there is [PhantomJS][] for example but we needed real browsers like Chrome or Firefox to run our tests on, one reason was to get better test confidence and the other was that [Protractor][] doesn't [play nice][prot-browser-support] with [PhantomJS][].
Recently [Wallaby.js][] announced they will support [Electron][] as an alternative to [PhantomJS][] because it allows to use the latest Chromium/V8 which might be equivalent to running in Chrome however it sill needs a display so [xvfb][xvfb-electron] is needed.

With [Selenium][], you can always run your tests locally but as soon as your tests runs the browser popping up in your main display can be annoying, you could configure your windows manager to move it automatically to another workspace for example and similar solutions exists but why going into all those troubles if you can just `docker run selenium`.

You can also configure a [headless Xvfb selenium][xvfb-sel] as it is a common use case in Jenkins CI but, again, why going into the trouble now [docker][] exists.

So back in 2014 the first thing I did was googling "selenium in docker", looked around 2 to 3 projects that were floating around but not well maintained so decided to create my own.

<h4 id="LONG">How long has it been around?</h4>

It started mid 2014 so almost 2 years, it [wasn't maintained consistently][gource] all these time but yes lately thanks to my role here at [Zalando][] and the fact that some teams here are using it.

<h4 id="TESTED">How is it tested? How is being built/deployed?</h4>

It has tests that run seamlessly [locally][tests] or in [Travis][travis-build] plus deploy automation using [TravisCI docker infrastructure][travis-docker]

The reason for pushing the new releases (docker images) from [Travis][travis-build] instead of using docker [automated builds][auto-builds] is that a [CI][] tool allows running arbitrary scripting like **tests** before pushing a broken image like happened for example at issue [208][stock-208]

<h4 id="PROMO">Have you done promotions on the project, or did people just learn of it in passing?</h4>

There was no promotion in the beginning, I suppose the success of it is due to the fact that is an obvious use case for any developer that needs [Selenium][] and knows how handy [docker][] technology is regarding disposable infrastructure.

Automation testers probably Google 2 words: *selenium* and *docker* then the top results are the official project and secondly this one or sometimes the other way around depending on Google mood *(i.e. Google algorithm in relation to the browser user stats)*.

<h4 id="PITCH">How did you get some of our Zalando teams to use it? How did you make the pitch?</h4>

When I started at [Zalando][] in March 2015 we didn't have [Sauce Labs][sauce], only a centralized [Selenium Grid][grid] in our data center which acted as a kind of [SPOF][] (Single Point of Failure) for our [Zalando teams][zal-teams] let alone the fact you couldn't see the tests running nor have recorded video results which are 2 features of this project.

My team, in charge of the Test Infrastructure, later on managed to acquire [Sauce Labs][sauce] enterprise which has all these features and support hundreds of browsers combinations so is the natural preferred way of getting a front-end testing infrastructure these days but [docker-selenium][] still keeps 3 advantages:

- **cost**: is free.
- **speed**: runs around 2x faster than a paid cloud based [Selenium][] solution.
- **security**: no need to tunnel your local app to a third party cloud solution.

<h4 id="SPIKE">Has there been any noticeable spike in followers/stars/etc that you've noticed during the time it's been public?</h4>

There was a slightly spike after one of contributors, [@rubytester][rubytester], made a [presentation][] back in September 2015.

Sometimes when someone with many followers [tweets about it][tweet1] but other than that the popularity growth has being consistent. Unfortunately I can't analyze this, back in time, out of github [analytics][] because there is no way to customize the dates, yet.

<h4 id="USERS">How did you acquire users like Nvidia?</h4>

I suppose most users come from Google search results as shown in the [traffic stats][analytics].

Some of these users generously asked me to add them in the *"Who is using this"* list like in the case of Nvidia for example when I was contacted directly by [Tony Carrillo][tony] via his corporate email *@nvidia.com*.

In the case of [Algolia][] I asked [@vvo][] after he pointed it out in a github issue.

From now on, when I remember it, I try to ask the users that open issues or send PRs to add their companies to this list as it feels nice to see the list growing.

<h4 id="LEARNED">What have you learned during the project's lifespan? About:</h4>

##### Documentation

Good extensive documentation helps gain users for sure but should always include how to get started quickly for people that want to use it ASAP without needing to acquire a deep knowledge of the tool.

##### Getting users

A couple of users wrote me they preferred my project because it was well maintained, up to date and issues were addressed quickly (no more than 3 days).
I can understand that in a huge widely used project like [AngularJS][] you get to see hundreds of [open issues without comments][angular-issues] nor assignee nor labels or 36 issues unattended like I see today [in docker][docker-issues] but some projects that have that huge amount of incoming opened issues and yet you still see them not even labeled, like the author not caring enough.

##### Working with contributors

When [Matthew Smith][mtscout6] aka @mtscout6 jumped into the project, 4 months after it started, great things happened. He made a few interesting [improvements][matt-improv] but moreover we started conversations about moving [docker-selenium][] to the official [SeleniumHQ][] organization, Matt pushed this, contacted Mozilla guys and what not so it [happened][] and for a while we were maintaining only that one but I decided to continue maintaining mine with differentiated [features][] and that's why 2 project for the same purpose exist today.

##### Technical debt

Main technical debt now is issue [31][] "Comply with docker official-images requisites" and maybe also issue [40][] to "Split browser capabilities into separate images". Probably also to improve the bash scripting by using functions with proper unit tests.

##### Testing

The [official][stock] one at [SeleniumHQ][] is using [CircleCI][] while [elgalu/selenium][] uses [TravisCI][] so tests basically have a couple of scenarios, running front-end tests on Chrome, on Firefox and restarting the container to check it still works after that. We should potentially add more tests for each bug that comes up to increase coverage in the future.

<h4 id="FUTURE">What is the future of this project? What's the roadmap?</h4>

Right now people tend to build long running selenium grids by using the [stock][] docker selenium images or this one however when you see [Sauce Labs][sauce] or [BrowserStack][] approach you realize the way to go is isolation, i.e. one machine or VM or docker container for each selenium session so those are the [next steps][next] for this project and perhaps a [Jenkins plugin][jenking-plugin]. Also [automate new versions detection][verdetection] e.g. new version of Chrome/Firefox/Selenium might be one of the chores to work on.


[lauri]: https://twitter.com/LauritaApplez
[raffo]: http://raffo.github.io/
[docker-selenium]: https://github.com/elgalu/docker-selenium
[stock]: https://github.com/SeleniumHQ/docker-selenium
[AppNexus]: https://en.wikipedia.org/wiki/AppNexus
[xvfb-sel]: http://elementalselenium.com/tips/38-headless
[xvfb-travis]: https://docs.travis-ci.com/user/gui-and-headless-browsers/#Using-xvfb-to-Run-Tests-That-Require-a-GUI
[xvfb-electron]: http://electron.atom.io/docs/tutorial/testing-on-headless-ci
[PhantomJS]: https://github.com/ariya/phantomjs
[Protractor]: https://github.com/angular/protractor
[prot-browser-support]: https://angular.github.io/protractor/#/browser-support
[TravisCI]: https://github.com/elgalu/docker-selenium/blob/master/.travis.yml
[travis-build]: https://travis-ci.org/elgalu/docker-selenium/builds/123103275
[CircleCI]: https://github.com/SeleniumHQ/docker-selenium/blob/master/circle.yml
[31]: https://github.com/elgalu/docker-selenium/issues/31
[40]: https://github.com/elgalu/docker-selenium/issues/40
[matt-improv]: https://github.com/elgalu/docker-selenium/commits?author=mtscout6
[happened]: https://github.com/SeleniumHQ/docker-selenium
[features]: https://github.com/elgalu/docker-selenium#notes-on-similar-repo-seleniumhqdocker-selenium
[presentation]: https://twitter.com/rubytester/status/644965076072574976
[rubytester]: https://github.com/rubytester
[tweet1]: https://twitter.com/vvoyer/status/687266750380027905
[tony]: https://www.linkedin.com/in/anthony-carrillo-1232422
[SPOF]: https://en.wikipedia.org/wiki/Single_point_of_failure
[analytics]: https://github.com/elgalu/docker-selenium/graphs/traffic
[sauce]: https://saucelabs.com/selenium/selenium-grid
[BrowserStack]: https://www.browserstack.com/automate
[AngularJS]: https://angularjs.org/
[Zalando]: https://tech.zalando.com/
[travis-docker]: https://docs.travis-ci.com/user/docker/
[Selenium]: https://github.com/SeleniumHQ/selenium
[docker]: https://github.com/docker/docker
[grid]: https://github.com/SeleniumHQ/selenium/wiki/Grid2
[elgalu/selenium]: https://github.com/elgalu/docker-selenium
[angular-issues]: https://git.io/vwntr
[docker-issues]: https://git.io/vwnq5
[mtscout6]: https://github.com/mtscout6
[SeleniumHQ]: https://github.com/SeleniumHQ
[next]: https://github.com/elgalu/docker-selenium/issues/65#issuecomment-212462604
[jenking-plugin]: https://github.com/elgalu/docker-selenium/issues/80
[verdetection]: https://github.com/elgalu/docker-selenium/issues/81
[zal-teams]: https://tech.zalando.com/blog/radical-agility-with-autonomous-teams-and-microservices-in-the-cloud/
[Algolia]: https://www.algolia.com/
[@vvo]: https://github.com/vvo
[auto-builds]: https://docs.docker.com/docker-hub/builds
[CI]: https://en.wikipedia.org/wiki/Continuous_integration
[stock-208]: https://github.com/SeleniumHQ/docker-selenium/issues/208
[tests]: https://github.com/elgalu/docker-selenium/tree/master/test
[Wallaby.js]: https://wallabyjs.com
[Electron]: https://wallabyjs.com/docs/integration/electron.html
[gource]: ./gource.md
