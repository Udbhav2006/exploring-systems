FROM ruby:3.1

# Set environment variables
ENV RAILS_ENV=development

# Install system dependencies
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client yarn

# Set the working directory
WORKDIR /app

# 1. Copy only the Gemfile and Gemfile.lock first
COPY Gemfile Gemfile.lock ./

# 2. Install gems.
RUN gem install bundler && bundle install

# 3. Now, copy the rest of your application code
COPY . .


## FIX FOR THE nokogiri gem version problems: running bundle install again.
#Reason (scroll):
#essentially "repairs" the gem environment inside the container after all your local files (including any hidden, conflicting configurations) have been copied over. It forces Bundler to regenerate the necessary links and executable files so they match the container's environment perfectly.
RUN bundle install

# Expose the port
EXPOSE 3000

# The command to run when the container starts
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]

# Why symbolic link not needed?
