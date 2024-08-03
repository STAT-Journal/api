import { Button, notification } from "antd";
import { Line, LineChart, ResponsiveContainer } from "recharts";
import { useMutation, useQuery } from "urql";
import { graphql } from "../gql/codegen";
import { Moment, MomentType } from "../gql/codegen/graphql";


function momentResultToGraphData(result: Moment[] | undefined | null) {
    if (!result) {
        return [];
    }
    // chunk results into 10 minute intervals
    // [
    //   { good: 1, bad: 1},
    //   { good: 2, bad: 0},
    //   ...
    // ]
    const interval_minute_size = 10;
    let sorted = result.sort((a, b) => new Date(a.insertedAt).getTime() - new Date(b.insertedAt).getTime())
    let sortedStart = new Date(sorted[0].insertedAt);
    let sortedEnd = new Date(sorted[sorted.length - 1].insertedAt);

    let graphData: { good: number, bad: number }[] = [];
    let currentInterval = 0;
    let currentGood = 0;
    let currentBad = 0;
    for (let i = 0; i < sorted.length; i++) {
        const moment = sorted[i];
        const momentDate = new Date(moment.insertedAt);
        const diff = momentDate.getTime() - sortedStart.getTime();
        const diffMinutes = Math.floor(diff / 1000 / 60);
        if (diffMinutes >= interval_minute_size * currentInterval) {
            graphData.push({ good: currentGood, bad: currentBad });
            currentInterval += 1;
            currentGood = 0;
            currentBad = 0;
        }
        if (moment.type === MomentType.Good) {
            currentGood += 1;
        } else {
            currentBad += 1;
        }
    }

    return graphData;
}

export default function MomentComponent() {
    const momentQuery = graphql(`query listMoments {\n  listMoments {\n    type\n    insertedAt\n  }\n}`);
    const [momentResult] = useQuery({ query: momentQuery });
    const graphData = momentResultToGraphData(momentResult.data?.listMoments as Moment[] ?? null);
    console.log(graphData);
    const [api, contextHolder] = notification.useNotification();

    const momentMutation = graphql(`mutation createMoment($type: MomentType!) {\n  createMoment(type: $type) {\n    insertedAt\n    type\n  }\n}`);
    const [, createMoment] = useMutation(momentMutation);

    const handleCreateMoment = (type: MomentType) => {
        createMoment({ type })
        .then((result) => {
            if (result.error) {
                api.error({
                    message: 'Failed to create moment',
                    description: result.error.message,
                });
                return;
            }
            else {
                api.success({
                    message: 'Moment created',
                    description: 'Moment was successfully created',
                });
            }})};

    return (
        <div>
            {contextHolder}
            <div>
                <ResponsiveContainer width="100%" height={400}>
                    <LineChart data={graphData} >
                        <Line type="monotone" dataKey="good" stroke="#4CBB17" dot={false} />
                        <Line type="monotone" dataKey="bad" stroke="#E32636" dot={false} />
                    </LineChart>
                </ResponsiveContainer>
                <div>
                    <Button onClick={() => handleCreateMoment(MomentType.Good)}>😞</Button>
                    <Button onClick={() => handleCreateMoment(MomentType.Bad)}>😀</Button>
                </div>
            </div>
        </div>
    );
}