require 'test_helper'

class AnalyzeImagesJobTest < ActiveJob::TestCase
  test "works with empty image ids array" do
    begin
      AnalyzeImagesJob.perform_now([])
    rescue
      assert false, "Empty ids array should not raise exception"
    end
  end
  
  # todo analyze images job tests
  # test "image is analyzed" do
  # end

  # test "analyze images job is enqueued at portfolio creation" do
  # end
end
