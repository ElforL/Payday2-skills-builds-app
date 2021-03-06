class Subtree {
  int _spentPnts;
  List<int> _options;

  Subtree(){
    _spentPnts = 0;
    _options = [0,0,0,0,0,0];
  }

  Subtree.clone(Subtree source){
    this._spentPnts = source.getSpentPnts();
    this._options = [0,0,0,0,0,0];
    for (var i = 0; i < _options.length; i++) {
      this._options[i] = source._options[i];
    }
  }

  Subtree.fromJson(Map<String, dynamic> map){
    _spentPnts = map['spentPnts'];
    var optionsFromMap = map['options'];
    _options = new List<int>.from(optionsFromMap);
  }

  Map<String, dynamic> toJson(){
    return <String, dynamic>{
      'spentPnts': _spentPnts,
      'options': _options
    };
  }
  
  int getSpentPnts(){
    calcSpentPoints();
    return _spentPnts;
  }
  List<int> getOptions(){
    return _options;
  }

  void calcSpentPoints(){
    int total = 0;
    final pntsForTiers = [[1,4],[2,6],[3,9],[4,12]];

    for (var i = 0; i < _options.length; i++) {
      if(_options[i] == 0) continue;
      total += pntsForTiers[(i+1)~/2][_options[i]-1];
    }
    _spentPnts = total;
  }

  bool upgradeOption(int opNum, int availablePnts){
    if(opNum > 5 || opNum < 0) throw new ArgumentError("op_num should be from 0 to 5");
    if(_options[opNum] >= 2) return false;

    int opTier = (opNum+1)~/2;
    if(_spentPnts < _getPntsForTier(opTier)) return false;
    if(_getPntsOfOption(opNum, _options[opNum]) > availablePnts) return false;

    _spentPnts += _getPntsOfOption(opNum, _options[opNum]);
    _options[opNum]++;

    return true;
  }

  //needs updating ( fails in some cases )
  bool degradeOption(int opNum){
    if(opNum > 5 || opNum < 0) throw new ArgumentError("op_num should be from 0 to 5");
    if(_options[opNum] <= 0) return false;

    int opTier = (opNum+1)~/2;
    int nextTier = _getNextUsedTier(opNum);

    if (opTier != nextTier)
      if((_spentPnts - _spentPntsFromTier(nextTier)) - _getPntsOfOption(opNum, _options[opNum]-1) < _getPntsForTier(nextTier))
        return false;

    _options[opNum]--;
    _spentPnts -= _getPntsOfOption(opNum, _options[opNum]);
    
    return true;
  }

  int _getPntsForTier(int tier){
    switch (tier) {
      case 0: return 0;
      case 1: return 1;
      case 2: return 3;
      case 3: return 16;
      default: throw new ArgumentError("Tier should be from 0 to 3");
    }
  }

  int _getPntsOfOption(int opNum, int opStat){
    switch (opNum){
      case 0: if(opStat == 0) return 1; else return 3; break;
      case 1:
      case 2: if(opStat == 0) return 2; else return 4; break;
      case 3:
      case 4: if(opStat == 0) return 3; else return 6; break;
      case 5: if(opStat == 0) return 4; else return 8; break;
      default: throw new ArgumentError("op_num should be from 0 to 5");
    }
  }

  int _getNextUsedTier(int opNum){
    for (var i = opNum+1; i < _options.length; i++) {
      if((i+1)/2 == (opNum+1)/2) continue;
      if(_options[i] > 0){
          return (i+1)~/2;
      }
    }
    return (opNum+1)~/2;
  }

  int _spentPntsFromTier(int tier){
    final pntsForTiers = [[1,4],[2,6],[3,9],[4,12]];
    int points = 0;
    for (var i = tier * 2 - 1; i < _options.length; i++) {
      if(_options[i] == 0){continue;}
      points += pntsForTiers[(i+1)~/2][_options[i]-1];
    }
    return points;
  }

  void resetTree(){
    for (var i = 0; i < _options.length; i++) {
      _options[i] = 0;
    }
    _spentPnts = 0;
  }
}