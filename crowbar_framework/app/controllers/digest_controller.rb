# Copyright 2012, Dell 
# 
# Licensed under the Apache License, Version 2.0 (the "License"); 
# you may not use this file except in compliance with the License. 
# You may obtain a copy of the License at 
# 
#  http://www.apache.org/licenses/LICENSE-2.0 
# 
# Unless required by applicable law or agreed to in writing, software 
# distributed under the License is distributed on an "AS IS" BASIS, 
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
# See the License for the specific language governing permissions and 
# limitations under the License. 
# 

require 'digest/md5'

class DigestController < ApplicationController
  
  skip_before_filter :authenticate_user!
  before_filter :authenticate

  # Will only show this page if you digest auth
  def index
    if session[:digest_user]
      render :text => t('user.digest_success', :default=>'success')
    else
      render :text => "digest", :status => :unauthorized
    end
  end

  private
  
  # does the magic auth
  def authenticate

    authenticate_or_request_with_http_digest(User::DIGEST_REALM) do |username|
      u = User.find_by_username(username)
      session[:digest_user] = u.username
      u.digest_password
    end
    warden.custom_failure! if performed?
  end

end