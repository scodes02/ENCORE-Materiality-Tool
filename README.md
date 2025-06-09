Materiality Heat Map Analysis

This R script creates materiality heat maps and workbooks for organisations based by combining their procurement data with ENCORE (Exploring Natural Capital Opportunities, Risks and Exposure) data. 
The analysis maps procurement spending to nature pressure and ecosystem service dependency materiality ratings.

Overview

The script performs nature-related financial risk assessment by:
- Mapping procurement data (in Australian University Procurement Network (AUPN) to International Standard Industrial Classification (ISIC) Rev. 4
- Applying ENCORE materiality ratings for nature pressures and dependencies
- Creating visual heat maps that highlight areas of highest nature pressure and dependency
- Creating workbooks that highlight pressures and dependencies of specific suppliers

Data Requirements

Input Files
1. Procurement Data:
   - Contains organizational spending data with taxonomy classifications in AUPN or relevant classification system

2. Classification Mappings:
   - `AUPN_into_ISIC_Classification.xlsx`: Maps organizational procurement categories to ISIC codes
   -  If not in AUPN, a new mapping file with a relvant crosswalk table will be needed 
   - `isic_summary_classes.xlsx`: Consolidates ISIC categories into reporting categories - can be alterred to meet an
   organisations needs. These ones are aligned with the University of Melbourne's climate active reporting categories.

3. ENCORE Data:
   - `07. Pressure mat ratings.csv`: Environmental pressure materiality ratings by ISIC code
   - `06. Dependency mat ratings.csv`: Ecosystem service dependency ratings by ISIC code
   - `14. EXIOBASE NACE ISIC crosswalk.csv` can be useful if an organisation have existing NACE or EXIOBASE classifications of spend

Materiality Rating Scale
	-       VH (Very High)
	-	H (High)
	-	M (Medium)
	-	L (Low)
	-	VL (Very Low)
	-	ND/N/A - No data/Not applicable
	
Analysis Methodology

1. Data processing
- Maps organizational procurement categories to standardized ISIC economic activity codes
- Joins procurement spending data with ENCORE materiality ratings
- Handles data quality issues and removes duplicates

2. Materiality aggregation
Uses a "worst-case scenario" approach when consolidating multiple ISIC categories and underlying materiality ratings:
- Takes the highest materiality rating across all relevant economic activities
- Ensures conservative risk assessment for decision-making
- Important: This approach may inflate apparent risk levels and may be uninformative if there are too mnay VH ratings

3. Visualization
Creates two complementary heat maps:
- Pressure Heat Map: Shows nature pressures by spend category and magnitude of spend
- Dependency Heat Map: Shows ecosystem service dependencies by spend category and magnitude of spend

4. Excel workbook
Creates an excel workbook that outlines 

Understanding the ENCORE data

All information is taken directly from https://www.encorenature.org/en

Economic activities

Economic activities were categorized according to the International Standard Industrial Classification of All Economic Activities (ISIC), Revision 4. ISIC divides economic activities into Sections, which are further broken down into Divisions, Groups and Classes. ENCORE uses a list of 271 economic activities which correspond to ISIC Groups, with the exception of selected Groups that have been further broken down to align with ISIC Classes.

Materiality ratings

Materiality ratings in ENCORE aim to provide users with an indication of the significance of the potential nature-related dependencies and pressures identified for given economic activities. In ENCORE, “material” is interpreted as synonymous to significant or important to consider in the decision-making process. Fiduciary, regulatory or other dimensions of materiality are not considered in ENCORE materiality ratings.

ENCORE materiality ratings use a five-point rating scale of Very High (VH), High (H), Medium (M), Low (L) and Very Low (VL). They are designed for comparison of materiality across the entire economy, not within a specific sector. Each materiality rating is based on a set of quantitative or qualitative indicators. In some cases, we followed a blended approach with a combination of quantitative and a qualitative assessment of pressures and dependencies. Where there was suitable quantitative data available, use of quantitative indicators was prioritized.

Pressure materiality ratings

Pressures in ENCORE are defined as "in line with the Driver-Pressure-State-Impact-Response (DPSIR) framework, the ENCORE knowledge base defines the term ‘pressure’ as the use of a measurable quantity of a natural resource or release of measurable quantity of substances, physical and biological agents. The pressures trigger the mechanisms causing change in state of nature (i.e., ecosystems and their components). Some initiatives, such as the Taskforce on Nature-related Financial Disclosures (TNFD) or the Natural Capital Protocol, refer to pressures as 'impact drivers'."

The Pressures included:

Area of freshwater use- Freshwater area is used for the activity.- Examples of metrics include area of wetland, ponds, lakes, streams, rivers or peatland necessary to provide ecosystem services such as water purification, fish spawning, areas of infrastructure necessary to use rivers and lakes such as bridges, dams, and flood barriers, etc.- Impacts include hydrological changes, freshwater geomorphology and fluvial processes.

Area of land use- Activity uses land area.- Example metrics include area of agriculture by type, area of forest plantation by type, area of open cast mine by type, etc.

Area of seabed use- Seabed area is used for the activity.- Examples of metrics include area of aquaculture by type, area of seabed mining by type, etc.- Impacts include hydrological changes, freshwater geomorphology and fluvial processes.

Disturbances (e.g noise, light)- Activity produces noise or light pollution that has potential to harm organisms.- Examples of metrics include decibels and duration of noise, lumens and duration of light, at site of impact.

Emissions of GHG- Activity emits GHG.- Examples include volume of carbon dioxide (CO2), methane (CH4), nitrous oxide (N2O), Sulphur hexafluoride (SF6), Hydrofluorocarbons (HFCs), and perfluorocarbons (PFCs), etc.

Emissions of non-GHG air pollutants- Activity emits non GHG air pollutants.- Examples include volume of fine particulate matter (PM2.5) and coarse particulate matter (PM10), Volatile Organic Compounds (VOCs), mono-nitrogen oxides (NO and NO2, commonly referred to as NOx), Sulphur dioxide (SO2), Carbon monoxide (CO), etc.

Emissions of nutrient pollutants to water and soil- Activity emits nutrient pollutants that can lead to eutrophication.- Example metrics include volume discharged to receiving water body of nutrients (e.g., nitrates and phosphates).

Emissions of toxic pollutants to water and soil- Activity emits toxic pollutants that can directly harm organisms and the environment.- Examples include volume discharged to receiving water body of toxic substances (e.g., heavy metals and chemicals).

Generation and release of solid waste- Activity generates and releases solid waste.- Example metrics include volume of waste by classification (i.e., nonhazardous, hazardous, and radioactive), by specific material constituents (e.g., lead, plastic), or by disposal method (e.g., landfill, incineration, recycling, specialist processing).

Introduction of invasive species- Activity directly introduces non-native invasive species into areas of operation.

Other abiotic resource extraction- Activity extracts abiotic resources.- Examples include volume of mineral extracted.

Other biotic resource extraction (e.g. fish, timber)- Activity extracts biotic resources including fish and timber.- Examples of metrics include volume of wild-caught fish by species, number of wild-caught mammals by species, volume of timber by species, etc.

Volume of water use- Water is used for the activity.- Example metrics include volume of groundwater consumed, volume of surface water consumed, etc.

Dependeny materiality ratings/ecosystem services

Ecosystem services were classified according to the UN System of Environmental-Economic Accounting Ecosystem Accounting (SEEA - EA), which comprises three categories of ecosystem service: provisioning services (i.e., those related to the supply of food, fibre, fuel and water); regulating and maintenance services (i.e., those related to activities of filtration, purification, regulation and maintenance of air, water, soil, habitat and climate); and cultural services (i.e., the experiential and non-material services related to the perceived or realized qualities of ecosystems whose existence and functioning enables a range of cultural benefits to be derived by individuals).

Ecosystem Services Include:

Air filtration services- Air filtration services are the ecosystem contributions to the filtering of air-borne pollutants through the deposition, uptake, fixing and storage of pollutants by ecosystem components, particularly plants, that mitigates the harmful effects of the pollutants. This is most commonly a final ecosystem service.

Biological control services- Pest control services are the ecosystem contributions to the reduction in the incidence of species that may prevent or reduce the effects of pests on biomass production processes or other economic and human activity. This may be recorded as a final or intermediate service.- Disease control services are the ecosystem contributions to the reduction in the incidence of species that may prevent or reduce the effects of species on human health. This is most commonly a final ecosystem service.

Biomass provisioning services- Biomass provisioning services include the ecosystem contributions to the growth of the following: cultivated plants that are harvested by economic units for various uses including food and fibre production, fodder and energy; grazed biomass that is an input to the growth of cultivated livestock; cultivated livestock and livestock products (e.g. meat, milk, eggs, wool, leather); animals and plants (e.g. fish, shellfish, seaweed) in aquaculture facilities that are harvested for various uses; trees and other woody biomass in both cultivated (plantation) and uncultivated production contexts that are harvested for various uses including timber production and energy; fish and other aquatic biomass that are captured in uncultivated production contexts for various uses; wild animals, plants and other biomass that are captured and harvested in uncultivated production contexts for various uses. Biomass provisioning services are final ecosystem services (except the grazed biomass provisioning services, which may also be an intermediate service to livestock provisioning services).

Education, scientific and research services- Education, scientific and research services are the ecosystem contributions, in particular through the biophysical characteristics and qualities of ecosystems, that enable people to use the environment through intellectual interactions with the environment. This is a final ecosystem service.

Flood mitigation services- Coastal protection services are the ecosystem contributions of linear elements in the seascape, for instance coral reefs, sand banks, dunes or mangrove ecosystems along the shore, in protecting the shore and thus mitigating the impacts of tidal surges or storms on local communities. This is a final ecosystem service.- River flood mitigation services are the ecosystem contributions of riparian vegetation which provides structure and a physical barrier to high water levels and thus mitigates the impacts of floods on local communities. River flood mitigation services will be supplied together with peak flow mitigation services in providing the benefit of flood protection. This is a final ecosystem service.

Genetic material services- Genetic material services are the ecosystem contributions from all biota (including seed, spore or gamete production) that are used by economic units, for example (i) to develop new animal and plant breeds; (ii) in gene synthesis; or (iii) in product development directly using genetic material. This is most commonly recorded as an intermediate service to biomass provisioning.

Global climate regulation services- Global climate regulation services are the ecosystem contributions to the regulation of the chemical composition of the atmosphere and oceans that affect global climate through the accumulation and retention of carbon and other GHG (e.g., methane) in ecosystems and the ability of ecosystems to remove (sequester) carbon from the atmosphere. This is a final ecosystem service.

Local (micro and meso) climate regulation services- Local climate regulation services are the ecosystem contributions to the regulation of ambient atmospheric conditions (including micro and mesoscale climates) through the presence of vegetation that improves the living conditions for people and supports economic production. Examples include the evaporative cooling provided by urban trees ('green space'), the role of urban water bodies ('blue space') and the contribution of trees in providing shade for humans and livestock. This may be a final or intermediate service.

Noise attenuation services- Noise attenuation services are the ecosystem contributions to the reduction in the impact of noise on people that mitigates its harmful or stressful effects. This is most commonly a final ecosystem service.

Nursery population and habitat maintenance services- Nursery population and habitat maintenance services are the ecosystem contributions necessary for sustaining populations of species that economic units ultimately use or enjoy either through the maintenance of habitats (e.g., for nurseries or migration) or the protection of natural gene pools. This service is an intermediate service and may input to a number of different final ecosystem services including biomass provision and recreation-related services.

Other provisioning services - Animal-based energy- Physical labour is provided by domesticated or commercial species, including oxen, horses, donkeys, goats and elephants. These can be grouped as draught animals, pack animals and mounts.

Other regulating and maintenance service - Dilution by atmosphere and ecosystems- Water, both fresh and saline, and the atmosphere can dilute the gases, fluids and solid waste produced by human activity.

Other regulating and maintenance service - Mediation of sensory impacts (other than noise)- Vegetation is the main (natural) barrier used to reduce light pollution and other sensory impacts, limiting the impact it can have on human health and the environment.

Pollination services- Pollination services are the ecosystem contributions by wild pollinators to the fertilization of crops that maintains or increases the abundance and/or diversity of other species that economic units use or enjoy. This may be recorded as a final or intermediate service.

Rainfall pattern regulation services (at sub-continental scale)- Rainfall pattern regulation services are the ecosystem contributions of vegetation, in particular forests, in maintaining rainfall patterns through evapotranspiration at the sub-continental scale. Forests and other vegetation recycle moisture back to the atmosphere where it is available for the generation of rainfall. Rainfall in interior parts of continents fully depends upon this recycling. This may be a final or intermediate service.

Recreation-related services- Recreation-related services are the ecosystem contributions, in particular through the biophysical characteristics and qualities of ecosystems, that enable people to use and enjoy the environment through direct, in-situ, physical and experiential interactions with the environment. This includes services to both locals and non-locals (i.e. visitors, including tourists). Recreation-related services may also be supplied to those undertaking recreational fishing and hunting. This is a final ecosystem service.

Soil and sediment retention services- Soil erosion control services are the ecosystem contributions, particularly the stabilising effects of vegetation, that reduce the loss of soil (and sediment) and support use of the environment (e.g., agricultural activity, water supply). This may be recorded as a final or intermediate service.- Landslide mitigation services are the ecosystem contributions, particularly the stabilising effects of vegetation, that mitigates or prevents potential damage to human health and safety and damaging effects to buildings and infrastructure that arise from the mass movement (wasting) of soil, rock and snow. This is a final ecosystem service.

Soil quality regulation services- Soil quality regulation services are the ecosystem contributions to the decomposition of organic and inorganic materials and to the fertility and characteristics of soils, e.g., for input to biomass production. This is most commonly recorded as an intermediate service.

Solid waste remediation- Solid waste remediation services are the ecosystem contributions to the transformation of organic or inorganic substances, through the action of micro-organisms, algae, plants and animals that mitigates their harmful effects. This may be recorded as a final or intermediate service.

Spiritual, artistic and symbolic services- Spiritual artistic and symbolic services are the ecosystem contributions, in particular through the biophysical characteristics and qualities of ecosystems, that are recognised by people for their cultural, historical, aesthetic, sacred or religious significance. These services may underpin people's cultural identity and may inspire people to express themselves through various artistic media. This is a final ecosystem service.

Storm mitigation services- Storm mitigation services are the ecosystem contributions of vegetation including linear elements, in mitigating the impacts of wind, sand and other storms (other than water related events) on local communities. This is a final ecosystem service.

Visual amenity services- Visual amenity services are the ecosystem contributions to local living conditions, in particular through the biophysical characteristics and qualities of ecosystems that provide sensory benefits, especially visual. This service combines with other ecosystem services, including recreation-related services and noise attenuation services to underpin amenity values. This is a final ecosystem service.

Water flow regulation services- Baseline flow maintenance services are the ecosystem contributions to the regulation of river flows and groundwater and lake water tables. They are derived from the ability of ecosystems to absorb and store water, and gradually release water during dry seasons or periods through evapotranspiration and hence secure a regular flow of water. This may be recorded as a final or intermediate ecosystem service.- Peak flow mitigation services are the ecosystem contributions to the regulation of river flows and groundwater and lake water tables. They are derived from the ability of ecosystems to absorb and store water, and hence mitigate the effects of flood and other extreme water-related events. Peak flow mitigation services will be supplied together with river flood mitigation services in providing the benefit of flood protection. This is a final ecosystem service.

Water purification services- Water purification services are the ecosystem contributions to the restoration and maintenance of the chemical condition of surface water and groundwater bodies through the breakdown or removal of nutrients and other pollutants by ecosystem components that mitigate the harmful effects of the pollutants on human use or health. This may be recorded as a final or intermediate ecosystem service.

Water supply- Water supply services reflect the combined ecosystem contributions of water flow regulation, water purification, and other ecosystem services to the supply of water of appropriate quality to users for various uses including household consumption. This is a final ecosystem service.
