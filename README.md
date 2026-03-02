# DALIA

A containerized launcher for multi-agent systems written in
[DALI](https://github.com/AAAI-DISIM-UnivAQ/DALI), powered by **SWI-Prolog**.

---

## Pre-requisites

1. Install [Docker](https://docs.docker.com/engine/install/)
2. Clone [DALI](https://github.com/AAAI-DISIM-UnivAQ/DALI)
   - Check the compatibility table:  
     [DALI–DALIA Compatibility](https://github.com/lollix91/dalia/blob/main/compatibility.md)
   - Example:
     ```sh
     git clone --branch v2026.01a --depth 1 https://github.com/AAAI-DISIM-UnivAQ/DALI
     ```

---

## Installation

1. Open a command shell (Command Prompt, Bash, etc.)
2. Clone [DALIA](https://github.com/lollix91/dalia)
   - Check the compatibility table:  
     [DALI–DALIA Compatibility](https://github.com/lollix91/dalia/blob/main/compatibility.md)
   - Examples:
     ```sh
     git clone --branch 2026.01.30 --depth 1 https://github.com/lollix91/dalia
     ```
     or
     ```sh
     git clone --depth 1 https://github.com/lollix91/dalia
     ```
3. Navigate into the cloned repository:
   ```sh
   cd dalia
   ```

> **Note:** DALIA now uses SWI-Prolog (bundled in the Docker image). No Prolog license is required.

---

## Usage

To launch the system, use the following command structure:

```sh
./run --dali <PATH-TO-DALI-DIRECTORY> --src <PATH-TO-MAS-DIRECTORY> [--token <OPENAI_API_KEY>]
```

- `PATH-TO-DALI-DIRECTORY` is the path to the cloned DALI repository.
- `PATH-TO-MAS-DIRECTORY` is the path to the multi-agent system project folder.
- Two example projects are provided: `example` and `case_study_smart_agriculture`.

---

### Running with LLM Support (OpenAI)

To enable the LLM Bridge features (e.g. allowing agents to consult ChatGPT via `acquire_knowledge/2`),
provide your OpenAI API key using the `--token` parameter:

```sh
./run --dali ../DALI --src example --token sk-proj-xxxxxxxxxxxxxxxxxxxx
```

---

### Running Offline (No LLM)

If you omit the `--token` parameter, the system will start in **offline mode**.
Calls to the LLM service will receive a default *\"LLM disabled\"* response without
contacting external APIs.

```sh
./run --dali ../DALI --src example
```

---

## Example Projects

### Example 1: Emergency Response (`example`)

A multi-agent emergency response system with 9 agents:

| Agent | Role |
|-------|------|
| `sensor` | Detects events (fire, smoke, earthquake) and raises alarms |
| `coordinator` | Central coordinator, queries AI oracle, dispatches agents |
| `logger` | Logs all events and agent messages |
| `communicator` | Notifies people about emergencies |
| `evacuator` | Evacuates locations |
| `manager` | Dispatches appropriate equipment |
| `responder` | Responds at location with equipment |
| `mary`, `john` | People to be notified |

**Launch:**

```sh
./run --dali ../DALI --src example --token <YOUR_OPENAI_API_KEY>
```

**Test — send a fire event:**

In the user prompt, enter the following (one line at a time):

```prolog
sensor.
me.
send_message(sense(fire, rome), me).
```

**Expected flow:**
1. **sensor** detects fire, logs the event, sends alarm to coordinator
2. **coordinator** queries the AI oracle, dispatches evacuator, manager, and communicator
3. **evacuator** evacuates the location, reports back
4. **manager** dispatches equipment (firetruck), reports back
5. **communicator** notifies mary and john
6. **coordinator** (when both evacuated + equipped) dispatches responder
7. **responder** responds at location with equipment, reports done

---

### Example 2: Smart Agriculture (`case_study_smart_agriculture`)

A multi-agent precision agriculture system with 6 agents:

| Agent | Role |
|-------|------|
| `soil_sensor` | Receives soil readings (moisture, pH, field) |
| `weather_monitor` | Receives weather data (temperature, humidity, forecast) |
| `crop_advisor` | Queries AI oracle for advice, sends irrigation commands |
| `irrigation_controller` | Activates irrigation for specific fields |
| `farmer_agent` | Receives notifications about actions taken |
| `logger` | Logs all events |

**Launch:**

```sh
./run --dali ../DALI --src case_study_smart_agriculture --token <YOUR_OPENAI_API_KEY>
```

**Test — send soil and weather data:**

In the user prompt, enter the following commands (one line at a time, one command set at a time):

```prolog
% Read soil data (moisture=20, pH=6.5, field=north_field)
soil_sensor.
me.
send_message(read_soil(20, 6.5, north_field), me).

% High temperature + drought forecast
weather_monitor.
me.
send_message(weather_update(42, 15, drought), me).

% Acidic soil in east field
soil_sensor.
me.
send_message(read_soil(50, 4.0, east_field), me).

% Frost warning
weather_monitor.
me.
send_message(weather_update(0, 80, frost), me).
```

**Expected flow:**
1. **soil_sensor** / **weather_monitor** receive data and forward to crop_advisor
2. **crop_advisor** queries the AI oracle for agricultural advice
3. **crop_advisor** sends irrigation commands and advisory notifications
4. **irrigation_controller** activates irrigation for the relevant field
5. **farmer_agent** receives notifications about actions taken
