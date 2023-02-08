# Python script to clean Riot json from not used data
  
  
import json
import os


_NOT_ALLOWED_TYPES = [
    'Spell',
    'Ability',
    'Trap',
]


class Cards:
    
    def __init__(self):
        self.new_units = []
        self.new_spells = []

    def format_cards(self, raw_data_cards):
        for card in raw_data_cards:
            if card['type'] not in _NOT_ALLOWED_TYPES:
                if not self._check_repeated_cards(card, self.new_units):
                    new_unit_dict = {
                        'name': card['name'],
                        'regions': card['regions'],
                        'img': card['assets'][0]['fullAbsolutePath'],
                    }
                    self.new_units.append(new_unit_dict)
            else:
                if not self._check_repeated_cards(card, self.new_spells):
                    new_spells_dict = {
                        'name': card['name'],
                        'regions': card['regions'],
                        'img': card['assets'][0]['fullAbsolutePath'],
                    }
                    self.new_spells.append(new_spells_dict)
                
        parsed_data_cards = {
            'units': self.new_units, 
            'spells': self.new_spells
        }

        return parsed_data_cards
    
    def _check_repeated_cards(self, card, card_dict):
        if not card_dict:
            return False
        if card['name'] == card_dict[-1]['name'] and card['supertype'] != 'Champion':
            return True
        return False


class ManageJson:
    
    def __init__(self):
        self.script_path = os.path.dirname(os.path.realpath(__file__))
    
    def read_json_card(self):
        f = open('{}/assets/cards_test.json'.format(self.script_path))
        
        data = json.load(f)

        f.close()
        
        return data['data']
    
    def write_json_card(self, json_data):
        with open('{}/assets/cards.json'.format(self.script_path), 'w') as outfile:
            json.dump(json_data, outfile)


def main():
    mj = ManageJson()
    cards = Cards()
    raw_data_cards = mj.read_json_card()
    parsed_data_cards = cards.format_cards(raw_data_cards)
    mj.write_json_card(parsed_data_cards)

if __name__ == "__main__":
    main()
