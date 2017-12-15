require "httparty"
require "json"

module Roadmap
  include HTTParty

  def get_roadmap(roadmap_id)
  # my roadmap_id is 37
    response = self.class.get(api_url("roadmaps/#{roadmap_id}"), headers:{ "authorization" => @auth_token})
    @roadmap = JSON.parse(response.body)
  end

  def get_checkpoint(checkpoint_id)
    response = self.class.get(api_url("checkpoints/#{checkpoint_id}"), headers:{ "authorization" => @auth_token})
    @checkpoint = JSON.parse(response.body)
  end

  def create_submission(checkpoint_id, assignment_branch, assignment_commit_link, comment, enrollment_id = @user_id)
  # my enrollment_id is 34208
  # this checkpoint_id is 2162
  response = self.class.post(api_url("checkpoint_submissions"),
             body: {
               "checkpoint_id": checkpoint_id,
               "assignment_branch": assignment_branch,
               "assignment_commit_link": assignment_commit_link,
               "comment": comment,
               "enrollment_id": enrollment_id
             },
             headers: { "authorization" => @auth_token })
    @submission_id = response.body["id"]
    response
  end

  def update_submission(checkpoint_id, assignment_branch, assignment_commit_link, comment, enrollment_id = @user_id, id = @submission_id)
  response = self.class.put(api_url("checkpoint_submissions/:#{id}"),
            body: {
               "checkpoint_id": checkpoint_id,
               "assignment_branch": assignment_branch,
               "assignment_commit_link": assignment_commit_link,
               "comment": comment,
               "enrollment_id": enrollment_id
            },
            headers: { "authorization" => @auth_token })
  end

  private

  def api_url(endpoint)
    "https://www.bloc.io/api/v1/#{endpoint}"
  end
end
