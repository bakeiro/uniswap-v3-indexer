/* TypeScript file generated from Handlers.res by genType. */

/* eslint-disable */
/* tslint:disable */

const HandlersJS = require('./Handlers.res.js');

import type {HandlerTypes_eventConfig as Types_HandlerTypes_eventConfig} from './Types.gen';

import type {UniswapV3Pool_Burn_eventFilters as Types_UniswapV3Pool_Burn_eventFilters} from './Types.gen';

import type {UniswapV3Pool_Burn_event as Types_UniswapV3Pool_Burn_event} from './Types.gen';

import type {UniswapV3Pool_Mint_eventFilters as Types_UniswapV3Pool_Mint_eventFilters} from './Types.gen';

import type {UniswapV3Pool_Mint_event as Types_UniswapV3Pool_Mint_event} from './Types.gen';

import type {chain as Types_chain} from './Types.gen';

import type {contractRegistrations as Types_contractRegistrations} from './Types.gen';

import type {fnWithEventConfig as Types_fnWithEventConfig} from './Types.gen';

import type {genericContractRegisterArgs as Internal_genericContractRegisterArgs} from 'envio/src/Internal.gen';

import type {genericContractRegister as Internal_genericContractRegister} from 'envio/src/Internal.gen';

import type {genericHandlerArgs as Internal_genericHandlerArgs} from 'envio/src/Internal.gen';

import type {genericHandler as Internal_genericHandler} from 'envio/src/Internal.gen';

import type {handlerContext as Types_handlerContext} from './Types.gen';

import type {onBlockArgs as Envio_onBlockArgs} from 'envio/src/Envio.gen';

import type {onBlockOptions as Envio_onBlockOptions} from 'envio/src/Envio.gen';

export const UniswapV3Pool_Mint_contractRegister: Types_fnWithEventConfig<Internal_genericContractRegister<Internal_genericContractRegisterArgs<Types_UniswapV3Pool_Mint_event,Types_contractRegistrations>>,Types_HandlerTypes_eventConfig<Types_UniswapV3Pool_Mint_eventFilters>> = HandlersJS.UniswapV3Pool.Mint.contractRegister as any;

export const UniswapV3Pool_Mint_handler: Types_fnWithEventConfig<Internal_genericHandler<Internal_genericHandlerArgs<Types_UniswapV3Pool_Mint_event,Types_handlerContext,void>>,Types_HandlerTypes_eventConfig<Types_UniswapV3Pool_Mint_eventFilters>> = HandlersJS.UniswapV3Pool.Mint.handler as any;

export const UniswapV3Pool_Burn_contractRegister: Types_fnWithEventConfig<Internal_genericContractRegister<Internal_genericContractRegisterArgs<Types_UniswapV3Pool_Burn_event,Types_contractRegistrations>>,Types_HandlerTypes_eventConfig<Types_UniswapV3Pool_Burn_eventFilters>> = HandlersJS.UniswapV3Pool.Burn.contractRegister as any;

export const UniswapV3Pool_Burn_handler: Types_fnWithEventConfig<Internal_genericHandler<Internal_genericHandlerArgs<Types_UniswapV3Pool_Burn_event,Types_handlerContext,void>>,Types_HandlerTypes_eventConfig<Types_UniswapV3Pool_Burn_eventFilters>> = HandlersJS.UniswapV3Pool.Burn.handler as any;

/** Register a Block Handler. It'll be called for every block by default. */
export const onBlock: (_1:Envio_onBlockOptions<Types_chain>, _2:((_1:Envio_onBlockArgs<Types_handlerContext>) => Promise<void>)) => void = HandlersJS.onBlock as any;

export const UniswapV3Pool: { Mint: { handler: Types_fnWithEventConfig<Internal_genericHandler<Internal_genericHandlerArgs<Types_UniswapV3Pool_Mint_event,Types_handlerContext,void>>,Types_HandlerTypes_eventConfig<Types_UniswapV3Pool_Mint_eventFilters>>; contractRegister: Types_fnWithEventConfig<Internal_genericContractRegister<Internal_genericContractRegisterArgs<Types_UniswapV3Pool_Mint_event,Types_contractRegistrations>>,Types_HandlerTypes_eventConfig<Types_UniswapV3Pool_Mint_eventFilters>> }; Burn: { handler: Types_fnWithEventConfig<Internal_genericHandler<Internal_genericHandlerArgs<Types_UniswapV3Pool_Burn_event,Types_handlerContext,void>>,Types_HandlerTypes_eventConfig<Types_UniswapV3Pool_Burn_eventFilters>>; contractRegister: Types_fnWithEventConfig<Internal_genericContractRegister<Internal_genericContractRegisterArgs<Types_UniswapV3Pool_Burn_event,Types_contractRegistrations>>,Types_HandlerTypes_eventConfig<Types_UniswapV3Pool_Burn_eventFilters>> } } = HandlersJS.UniswapV3Pool as any;
