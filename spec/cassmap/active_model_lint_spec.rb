require "spec_helper"

class CassmapModel < Cassmap::Base
end

describe CassmapModel do
  it_behaves_like "ActiveModel"
end
