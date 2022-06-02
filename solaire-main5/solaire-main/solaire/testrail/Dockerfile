FROM ruby:2.7.0
RUN apt-get update
RUN apt-get install -y unzip xvfb libxi6 libgconf-2-4
# Setting up Env path
ENV APP_HOME /cucumber
ENV HOME /cucumber
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

# Install google chrome
RUN wget http://mirror.cs.uchicago.edu/google-chrome/pool/main/g/google-chrome-stable/google-chrome-stable_96.0.4664.93-1_amd64.deb
RUN apt-get install -y -f ./google-chrome-stable_96.0.4664.93-1_amd64.deb

# Download and install Chromedriver (Doc: https://chromedriver.storage.googleapis.com/)
ENV CHROMEDRIVER_VERSION 96.0.4664.18
RUN apt-get install -y unzip
RUN wget https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip
RUN unzip chromedriver_linux64.zip
RUN chmod a+rx chromedriver
RUN mv chromedriver /usr/bin/chromedriver.wrapped
RUN echo "#!/bin/bash" >> /usr/bin/chromedriver

#RUN echo "/usr/bin/chromedriver.wrapped -port=4446 $@ >$APP_HOME/log.txt 2>&1" >> /usr/bin/chromedriver
RUN echo "/usr/bin/chromedriver.wrapped $@ >$APP_HOME/log.txt 2>&1" >> /usr/bin/chromedriver
RUN chmod a+rx /usr/bin/chromedriver
RUN echo $PATH

# Download and install Ruby Gems
ADD Gemfile $APP_HOME/
ADD Gemfile.lock $APP_HOME/
ENV BUNDLER_VERSION='2.1.4'
RUN gem install bundler --no-document -v '2.1.4'
RUN bundle install
CMD ["bundle", "exec", "cucumber --quiet WEB_DRIVER=headless -t @$SCOPE"]