PROJECT = shotgun

DEPS = lager gun sync
dep_lager = git https://github.com/basho/lager.git 2.1.0
dep_gun = git https://github.com/extend/gun.git master
dep_sync = git https://github.com/rustyio/sync.git master

include erlang.mk

ERLC_OPTS += +'{parse_transform, lager_transform}' +warn_missing_spec
TEST_ERLC_OPTS += +'{parse_transform, lager_transform}'

RUN := erl -pa ebin -pa deps/*/ebin -smp enable -s sync -boot start_sasl ${ERL_ARGS}
NODE ?= ${PROJECT}

shell: app
	if [ -n "${NODE}" ]; then ${RUN} -name ${NODE}@`hostname` -s ${PROJECT} -s sync -config rel/sys.config; \
	else ${RUN} -s ${PROJECT} -config rel/sys.config; \
	fi

erldocs: all
	erldocs . -o docs
