require_relative './connect_4_run.rb'

describe Connect4 do
  describe '.run' do
    before do
      allow(described_class).to receive(:puts)
    end

    context 'when the user does not ask to start a new game' do
      before do
        allow(described_class).to receive(:gets).and_return(%w[NO No no N n].sample)
      end

      10.times do
        it 'prompts the user about starting a game exactly once' do
          expect(described_class).to receive(:puts).with('Start a new game? (Y/N)').once
          described_class.run
        end

        it 'does not initialize a new game' do
          expect(Game).not_to receive(:new)
        end
      end
    end

    context 'when the user asks to play exactly one game' do
      it 'prompts the user about starting a game exactly twice' do
        
      end

      it 'initializes exactly one new game' do
        
      end
    end

    context 'when the user asks to play exactly two games' do
      it 'prompts the user about starting a game exactly three times' do
        
      end

      it 'initializes exactly two new games' do
        
      end
    end

    context 'when the user asks to play a random number of games' do
      it 'prompts the user about starting a game the corresponding number of times + 1' do
        
      end

      it 'initializes the corresponding number of new games' do
        
      end
    end

    context 'when the user inputs something besides y/yes or n/no in response to the prompt' do
      it 'does not initialize a new game' do
        
      end
    end
  end
end
