import { Button } from "antd";
import { Line, LineChart, ResponsiveContainer } from "recharts";
import { useMutation, useQuery } from "urql";
import { graphql } from "../gql/codegen";
import { MomentType } from "../gql/codegen/graphql";
import { useNotification } from "../providers/Notification";


export default function MomentComponent() {
    const momentQuery = graphql(`query listMomentsForGraph {\n  listMomentsForGraph {\n    good\n    bad\n    insertedAt\n  }\n}`);
    const [momentResult] = useQuery({ query: momentQuery });

    console.log(momentResult.data?.listMomentsForGraph)

    const {api} = useNotification();

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
            <div>
                <ResponsiveContainer width="100%" height={400}>
                    <LineChart data={momentResult.data?.listMomentsForGraph??[]} >
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