#include "PluginProcessor.h"

VstPluginAudioProcessor::VstPluginAudioProcessor()
    : AudioProcessor(BusesProperties()
        .withInput("Input", juce::AudioChannelSet::stereo(), true)
        .withOutput("Output", juce::AudioChannelSet::stereo(), true))
{
}

VstPluginAudioProcessor::~VstPluginAudioProcessor() {}

void VstPluginAudioProcessor::prepareToPlay(double sampleRate, int samplesPerBlock) {}

void VstPluginAudioProcessor::releaseResources() {}

void VstPluginAudioProcessor::processBlock(juce::AudioBuffer<float>& buffer, 
                                         juce::MidiBuffer& midiMessages) 
{
    for (const auto metadata : midiMessages) {
        auto message = metadata.getMessage();
        if (message.isNoteOn()) {
            lastNotePlayed = juce::String(message.getNoteNumber()) + 
                           " (vel: " + juce::String(message.getVelocity()) + ")";
            DBG("Note On: " << message.getNoteNumber() 
                << " Velocity: " << message.getVelocity());
        }
        else if (message.isPitchWheel()) {
            currentPitchBend = message.getPitchWheelValue();
        }
        else if (message.isController() && message.getControllerNumber() == 1) {
            currentModulation = message.getControllerValue();
        }
    }
    buffer.clear();
}

juce::AudioProcessorEditor* VstPluginAudioProcessor::createEditor()
{
    return new VstPluginAudioProcessorEditor(*this);
}

void VstPluginAudioProcessor::getStateInformation(juce::MemoryBlock& destData) {}

void VstPluginAudioProcessor::setStateInformation(const void* data, int sizeInBytes) {}

juce::AudioProcessor* JUCE_CALLTYPE createPluginFilter()
{
    return new VstPluginAudioProcessor();
} 