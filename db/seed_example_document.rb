document_record = Document.create!({})
title_point = {text: "Delay Selection by Spike-Timing-Dependent Plasticity in Recurrent Networks of Spiking Neurons Receiving Oscillatory Inputs", 
						 	 context_id: Context.where(description: "Title").first.id, 
						   document_id: document_record.id,
						   document_position: 0 }
title_point_record = Point.create(title_point)
document_record.root_point_id = title_point_record.id
document_record.save
main_points = [{text: "Learning rules, such as spike-timing-dependent plasticity (STDP), change the structure of networks of neurons based on the firing activity. ", 
						 	  context_id: Context.where(description: "Background").first.id, 
						    document_id: document_record.id,
						    document_position: 1 },
						   {text: "A network level understanding of these mechanisms can help infer how the brain learns patterns and processes information. ",
						 	  context_id: Context.where(description: "Background").first.id, 
						    document_id: document_record.id,
						    document_position: 2 },
						   {text: "Previous studies have shown that STDP selectively potentiates feed-forward connections that have specific axonal delays, and that this underlies behavioral functions such as sound localization in the auditory brainstem of the barn owl. ", 
						 	  context_id: Context.where(description: "Background").first.id, 
						    document_id: document_record.id,
						    document_position: 3 },
						   {text: "In this study, we investigated how STDP leads to the selective potentiation of recurrent connections with different axonal and dendritic delays during oscillatory activity. ", 
						 	  context_id: Context.where(description: "Method").first.id, 
						    document_id: document_record.id,
						    document_position: 4 },
						   {text: "We developed analytical models of learning with additive STDP in recurrent networks driven by oscillatory inputs, and supported the results using simulations with leaky integrate-and-fire neurons. ", 
						 	  context_id: Context.where(description: "Method").first.id, 
						    document_id: document_record.id,
						    document_position: 5 },
						   {text: "Our results showed selective potentiation of connections with specific axonal delays, which depended on the input frequency. ", 
						 	  context_id: Context.where(description: "Result").first.id, 
						    document_id: document_record.id,
						    document_position: 6 },
						   {text: "In addition, we demonstrated how this can lead to a network becoming selective in the amplitude of its oscillatory response to this frequency. ", 
						 	  context_id: Context.where(description: "Result").first.id, 
						    document_id: document_record.id,
						    document_position: 7 },
						   {text: "We extended this model of axonal delay selection within a single recurrent network in two ways. First, we showed the selective potentiation of connections with a range of both axonal and dendritic delays. ", 
						 	  context_id: Context.where(description: "Result").first.id, 
						    document_id: document_record.id,
						    document_position: 8 },
						   {text: "Second, we showed axonal delay selection between multiple groups receiving out-of-phase, oscillatory inputs. ", 
						 	  context_id: Context.where(description: "Result").first.id, 
						    document_id: document_record.id,
						    document_position: 9 },
						   {text: "We discuss the application of these models to the formation and activation of neuronal ensembles or cell assemblies in the cortex, and also to missing fundamental pitch perception in the auditory brainstem. ", 
						 	  context_id: Context.where(description: "Discussion").first.id, 
						    document_id: document_record.id,
						    document_position: 10 }]
main_point_records = Point.create(main_points)
subpointlinks = main_point_records.each_with_index.map { |pnt,i| 
	{
		point_id: title_point_record.id,
		subpoint_id: pnt.id,
		position: i
	}
}
Subpointlink.create(subpointlinks)
some_subpoints = [{text: "Spike-timing-dependent plasticity (STDP) is an experimentally observed learning rule that changes synaptic strengths based on the relative timing of pre- and post-synaptic spikes (action potentials). ", 
							 	   context_id: Context.where(description: "Background").first.id, 
							     document_id: document_record.id,
						    	 document_position: 11 },
							    {text: "Gerstner et. al. first proposed it as an unsupervised Hebbian learning rule that could select feed-forward connections with specific axonal delays. ",
							 	   context_id: Context.where(description: "Background").first.id, 
							     document_id: document_record.id,
						    	 document_position: 12 },
							    {text: "They showed that it could be used to achieve the high degree of temporal coherence that had been observed at frequencies of up to 8kHz in the auditory brainstem of barn owls. ", 
							 	   context_id: Context.where(description: "Background").first.id, 
							     document_id: document_record.id,
						    	 document_position: 13 },
							    {text: "This finding explained how a network could learn to perform sound localization using the time lag between the neural signals from the two ears. ", 
							 	   context_id: Context.where(description: "Background").first.id, 
							     document_id: document_record.id,
						    	 document_position: 14 },
							    {text: "Their study also demonstrated that the precise timing of spikes could be captured by STDP and that this was sufficient to explain how neurons in the auditory pathway could learn to distinguish such fine temporal differences in an unsupervised fashion. ", 
							 	   context_id: Context.where(description: "Background").first.id, 
							     document_id: document_record.id,
						    	 document_position: 15 },
							    {text: "In general, STDP has the ability to encode temporal correlations in neuronal activity, such as oscillations, into the functional structure of networks of neurons that have axonal and dendritic propagation delays. ", 
							 	   context_id: Context.where(description: "Background").first.id, 
							     document_id: document_record.id,
						    	 document_position: 16 }]
some_subpoint_records = Point.create(some_subpoints)
subpointlinks = [
	{
		point_id: main_point_records[0].id,
		subpoint_id: some_subpoint_records[0].id,
		position: 0
	}, {
		point_id: main_point_records[0].id,
		subpoint_id: some_subpoint_records[1].id,
		position: 1
	}, {
		point_id: some_subpoint_records[1].id,
		subpoint_id: some_subpoint_records[2].id,
		position: 0
	}, {
		point_id: some_subpoint_records[1].id,
		subpoint_id: some_subpoint_records[3].id,
		position: 1
	}, {
		point_id: some_subpoint_records[1].id,
		subpoint_id: some_subpoint_records[4].id,
		position: 2
	}, {
		point_id: main_point_records[0].id,
		subpoint_id: some_subpoint_records[5].id,
		position: 2
	}
]
Subpointlink.create(subpointlinks)
references = [
	{text: "Markram H, Lubke J, Frotscher M, Sakmann B (1997) Regulation of synaptic efficacy by coincidence of postsynaptic APs and EPSPs. Science 275: 213-215. ", 
					 	   context_id: Context.where(description: "Reference").first.id, 
					     document_id: document_record.id,
						   document_position: 17 },
					    {text: "Bi GQ, Poo MM (1998) Synaptic modifications in cultured hippocampal neurons: Dependence on spike timing, synaptic strength, and postsynaptic cell type. J Neurosci 18: 10464-10472. ",
					 	   context_id: Context.where(description: "Reference").first.id, 
					     document_id: document_record.id,
						   document_position: 18 },
					    {text: "Dan Y, Poo MM (2004) Spike timing-dependent plasticity of neural circuits. Neuron 44: 23-30. ", 
					 	   context_id: Context.where(description: "Reference").first.id, 
					     document_id: document_record.id,
						   document_position: 19 },
					    {text: "Dan Y, Poo MM (2006) Spike timing-dependent plasticity: From synapse to perception. Physiol Rev 86: 1033-1048. ", 
					 	   context_id: Context.where(description: "Reference").first.id, 
					     document_id: document_record.id,
						   document_position: 20 },
					    {text: "Gerstner W, Kempter R, van Hemmen JL, Wagner H (1996) A neuronal learning rule for submillisecond temporal coding. Nature 383: 76-81. ", 
					 	   context_id: Context.where(description: "Reference").first.id, 
					     document_id: document_record.id,
						   document_position: 21 }]
reference_records = Point.create(references)
subpointlinks = [{
		point_id: some_subpoint_records[0].id,
		subpoint_id: reference_records[0].id,
		position: 0
	}, {
		point_id: some_subpoint_records[0].id,
		subpoint_id: reference_records[1].id,
		position: 1
	}, {
		point_id: some_subpoint_records[0].id,
		subpoint_id: reference_records[2].id,
		position: 2
	}, {
		point_id: some_subpoint_records[0].id,
		subpoint_id: reference_records[3].id,
		position: 3
	}, {
		point_id: some_subpoint_records[1].id,
		subpoint_id: reference_records[4].id,
		position: 3
	}
]
Subpointlink.create(subpointlinks)
