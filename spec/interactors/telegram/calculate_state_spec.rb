require "rails_helper"

RSpec.describe Telegram::CalculateState do
  subject { described_class }

  specify { expect(subject.run(value: "unknown", modifier: "unknown")).to be_invalid }
  specify { expect(subject.run!(value: "1", modifier: "unknown")).to eq("1") }

  # button AC
  specify { expect(subject.run!(value: "1", modifier: "AC")).to eq("0") }

  # button +
  specify { expect(subject.run!(value: "1", modifier: "+")).to eq("1 +") }
  specify { expect(subject.run!(value: "5 + 10", modifier: "+")).to eq("15") }
  specify { expect(subject.run!(value: "1 -", modifier: "+")).to eq("1 +") }

  # button -
  specify { expect(subject.run!(value: "1", modifier: "-")).to eq("1 -") }
  specify { expect(subject.run!(value: "5 - 10", modifier: "-")).to eq("-5") }
  specify { expect(subject.run!(value: "1 +", modifier: "-")).to eq("1 -") }

  # single combination test
  specify { expect(subject.run!(value: "1", modifier: "1")).to eq("11") }
  specify { expect(subject.run!(value: "11", modifier: "1")).to eq("111") }
  specify { expect(subject.run!(value: "11 + 1", modifier: "1")).to eq("11 + 11") }
  specify { expect(subject.run!(value: "1 +", modifier: "1")).to eq("1 + 1") }

  # zeroes
  specify { expect(subject.run!(value: "0", modifier: "0")).to eq("0") }
  specify { expect(subject.run!(value: "0 +", modifier: "0")).to eq("0 + 0") }
  specify { expect(subject.run!(value: "0", modifier: "1")).to eq("1") }
  specify { expect(subject.run!(value: "0 + 0", modifier: "1")).to eq("0 + 1") }
end
