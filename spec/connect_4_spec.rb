require_relative '../lib/connect_4.rb'

describe Connect4 do
  describe '.run' do
    let(:yes) { %w[YES Yes yes Y y].sample }
    let(:no) { %w[NO No no N n].sample }
    let(:game) { instance_double(Game) }

    before do
      allow(described_class).to receive(:puts)
      allow(Game).to receive(:new).and_return(game)
      allow(game).to receive(:play)
    end

    context 'when the user does not ask to start a new game' do
      before do
        allow(described_class).to receive(:gets).and_return(no)
      end

      10.times do
        it 'prompts the user about starting a game exactly once' do
          expect(described_class).to receive(:puts).with('Start a new game? (Y/N)').once
          described_class.run
        end

        it 'does not initialize or run a new game' do
          expect(Game).not_to receive(:new)
          expect(game).not_to receive(:play)
          described_class.run
        end

        it 'outputs a goodbye message' do
          expect(described_class).to receive(:puts).with(/bye/)
          described_class.run
        end
      end
    end

    context 'when the user asks to play exactly one game' do
      before do
        allow(described_class).to receive(:gets).and_return(yes, no)
      end

      10.times do
        it 'prompts the user about starting a game exactly twice' do
          expect(described_class).to receive(:puts).with('Start a new game? (Y/N)').twice
          described_class.run
        end

        it 'initializes and runs exactly one new game' do
          expect(Game).to receive(:new).once
          expect(game).to receive(:play).once
          described_class.run
        end

        it 'outputs a goodbye message' do
          expect(described_class).to receive(:puts).with(/bye/)
          described_class.run
        end
      end
    end

    context 'when the user asks to play a random number of games' do
      let(:games) { rand(100) }
      before do
        call_count = 0
        allow(described_class).to receive(:gets) do
          call_count += 1
          call_count == games + 1 ? no : yes
        end
      end

      10.times do
        it 'prompts the user about starting a game the corresponding number of times + 1' do
          expect(described_class).to receive(:puts).with('Start a new game? (Y/N)').exactly(games + 1).times
          described_class.run
        end

        it 'initializes the corresponding number of new games' do
          expect(Game).to receive(:new).exactly(games).times
          expect(game).to receive(:play).exactly(games).times
          described_class.run
        end

        it 'outputs a goodbye message' do
          expect(described_class).to receive(:puts).with(/bye/)
          described_class.run
        end
      end
    end

    context 'when the user inputs something besides y/yes or n/no in response to the prompt' do
      before do
        allow(described_class).to receive(:gets).and_return(%w[7 hello @ 23 )].sample)
      end

      10.times do
        it 'prompts the user about starting a game exactly once' do
          expect(described_class).to receive(:puts).with('Start a new game? (Y/N)').once
          described_class.run
        end

        it 'does not initialize or run a new game' do
          expect(Game).not_to receive(:new)
          expect(game).not_to receive(:play)
          described_class.run
        end

        it 'outputs a goodbye message' do
          expect(described_class).to receive(:puts).with(/bye/)
          described_class.run
        end
      end
    end
  end
end
