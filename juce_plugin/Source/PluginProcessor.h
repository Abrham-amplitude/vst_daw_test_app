#pragma once
#include <JuceHeader.h>

class VstPluginAudioProcessorEditor;  // Forward declaration

class VstPluginAudioProcessor : public juce::AudioProcessor {
public:
    VstPluginAudioProcessor();
    ~VstPluginAudioProcessor() override;

    void prepareToPlay (double sampleRate, int samplesPerBlock) override;
    void releaseResources() override;
    void processBlock (juce::AudioBuffer<float>&, juce::MidiBuffer&) override;

    juce::AudioProcessorEditor* createEditor() override;
    bool hasEditor() const override { return true; }

    const juce::String getName() const override { return JucePlugin_Name; }
    bool acceptsMidi() const override { return true; }
    bool producesMidi() const override { return false; }
    double getTailLengthSeconds() const override { return 0.0; }

    int getNumPrograms() override { return 1; }
    int getCurrentProgram() override { return 0; }
    void setCurrentProgram(int) override {}
    const juce::String getProgramName(int) override { return {}; }
    void changeProgramName(int, const juce::String&) override {}

    void getStateInformation(juce::MemoryBlock& destData) override;
    void setStateInformation(const void* data, int sizeInBytes) override;

    int getCurrentPitchBend() const { return currentPitchBend; }
    int getCurrentModulation() const { return currentModulation; }

private:
    juce::String lastNotePlayed;
    int currentPitchBend = 8192;
    int currentModulation = 0;
    
    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR(VstPluginAudioProcessor)
}; 