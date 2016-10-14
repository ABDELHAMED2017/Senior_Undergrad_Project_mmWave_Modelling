function Demodulation=Symbol_Demodulation(Signal,ChannelGain,ModulationDefinition)

MatchedFilter=ModulationDefinition.PulseShape;
SymbolDuration=ModulationDefinition.SymbolDuration;
SymbolEnergy=ModulationDefinition.ConstellationEnergy;
ConstellationMap=ModulationDefinition.ConstellationMap;
GrayCodeUnmapping=ModulationDefinition.GrayCodeUnmapping;
BitsPerSymbol=ModulationDefinition.BitsPerSymbol;

Demodulation=struct;

NumAntennas=size(Signal,1);
BitStream=cell(1,NumAntennas);

for cont=1:NumAntennas
    DetectedSymbol=conv(Signal(cont,:),MatchedFilter/SymbolDuration);
    DetectedSymbol=DetectedSymbol*sqrt(SymbolEnergy(cont))/ChannelGain(cont,cont);
    Sampling=SymbolDuration:SymbolDuration:length(DetectedSymbol);
    DetectedSymbol=DetectedSymbol(Sampling);
    DetectedSymbol=DetectedSymbol(1:end);
    Demodulation.Symbols{cont}=DetectedSymbol;
    DetectedSymbol=Demodulate_Constellation(ConstellationMap{cont},DetectedSymbol);
    DetectedSymbol=GrayCodeUnmapping{cont}(DetectedSymbol)-1;
    
    BitStream{cont}=dec2bin(DetectedSymbol,BitsPerSymbol(cont));
    
end

Stream=[];
for NumSymbol=1:length(DetectedSymbol)
    for cont=1:NumAntennas
        Stream=[Stream BitStream{cont}(NumSymbol,:)];
    end
end

Demodulation.Stream=Stream;

end