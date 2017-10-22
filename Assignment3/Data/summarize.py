import pandas as pd
import skvideo.io


def func(x):
    tmp = '../Video/{}.mp4'.format(x['ID'])
    metadata = skvideo.io.ffprobe(tmp)
    duration = metadata['video']['@duration']
    avg_frame_rate = metadata['video']['@avg_frame_rate']
    nb_frames = metadata['video']['@nb_frames']
    return pd.Series({
        'ID': x['ID'],
        'filename': '{}.mp4'.format(x['ID']),
        'nb_frames': nb_frames,
        'duration': duration,
        'avg_frame_rate': eval(avg_frame_rate)
    })


data_id = pd.read_csv('./id.txt', header=None)
data_id.columns = ['ID']
summary = data_id.apply(func, 1)
summary[['ID', 'nb_frames', 'duration', 'avg_frame_rate',
         'filename']].to_csv('summary.csv')
